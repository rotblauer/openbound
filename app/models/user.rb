# Errata and known issues.

# ? has_many :works, dependent: :destroy?
# ? how to handle the case when a user changes emails w/r/t email and activations

class User < ActiveRecord::Base
  extend FriendlyId
  include ActionView::Helpers::NumberHelper

  include PublicActivity::Model
  tracked

  friendly_id :slug_candidates, use: :slugged

  devise :trackable

  has_many :affiliations
  has_many :schools, through: :affiliations

  has_many :linked_accounts, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :works#, dependent: :destroy # --> projects
  has_many :comments, dependent: :destroy
  has_many :gradients, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :recommendeds, dependent: :destroy
  has_many :suggesteds, through: :works, dependent: :destroy
  has_many :visits

  mount_uploader :avatar, AvatarUploader

  attr_accessor :remember_token,
                :activation_token,
                :reset_token,
                :email_update_token


  with_options if: :passwordy? do |pass|
    pass.has_secure_password # BCrypt?
    pass.validates :password, presence: true, length: { minimum: 6 }, on: :create
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    pass.validates :email, length: { maximum: 255 }, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  end
  # with_options if: :oauthy? do |oauth|
  #   oauth.validates :has_oauth, value: true
  # end

  # FIXME: this is not quite good....
  def passwordy?
    # puts "*****************----------------> Handling user as PASSWORDY."
    !self.has_oauth?
  end
  def oauthy?
    # puts "*****************----------------> Handling user as OAUTHY."
    self.has_oauth?
  end

  # activation digest, default profile url, and school_id are automatically assigned before create at Sign Up (users@new).
  before_create :create_activation_digest, :create_uuid
  after_create :init_affiliation

  # email is downcased for uniqueness checking
  before_save   :downcase_email

  # Updates associated school users_count.
  # after_commit :update_school_users_count, on: [:create, :destroy]

	validates :name, presence: true,
                   length: { maximum: 50 }
  validates_exclusion_of :name, in: %w( admin administrator superuser hotshit ), message: 'You wish!'

  validates :new_email, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false, scope: [:email, :new_email], allow_nil: true },
                    allow_blank: true,
                    on: :update

  # Turn require academic email OFF.
  ##
  ###
  # validate :email_seems_academic, on: :create # <-- (only on create; "once a student, always a student")
    VALID_EMAIL_REGEX_EDU = /\A[\w+\-.]+@[a-z\d\-.]+\.["edu"]+\z/i # <-- constant regex checks for ...@...".edu"
    VALID_EMAIL_REGEX_AC_UK = /\A[\w+\-.]+@[a-z\d\-.]+\.["ac.uk"]+\z/i # <-- constant regex checks for ...@...".ac.uk" [guaranteed British ACademic institutions]
    def email_seems_academic
      unless (Swot::is_academic? self.email) || (self.email =~ VALID_EMAIL_REGEX_EDU || VALID_EMAIL_REGEX_AC_UK)   # https://github.com/leereilly/swot
        errors.add(:email, " must be academic.")
      end
    end

  if !Rails.env.test?
    validates :avatar, file_size: { less_than_or_equal_to: 5.megabytes } # <-- comment all document validation while seeding
  end

  devise :trackable # fills in 4 or 5 columns in user table about session history stuff like IP, log-in count
  is_impressionable # 'impressionist' gem method for tracking view counts; towards user-popularity stats stuff



  # If one affiliation, pick it.
  # Else, pick most recent college.
  def school_primary
    # Should be unused but prevent bugs.
    if affiliations.any?

      # Return school where affiliation.is_primary.
      # If there are none of these, we'll make a best guess once and assign the
      # is_primary attribute so we only have to guess once. Shaving milliseconds, you know.
      # There should be only one of these but best to be safe.
      return affiliations.where(is_primary: true).first.school if affiliations.where(is_primary: true).any?

      # This gives preference to schools that have (so far) been assigned by facebook.
      collegiate_affiliations = affiliations.where(institution_type: 'College')
      best_guess = ''
      if collegiate_affiliations.any?
        if collegiate_affiliations.count == 1

          # Here's our best guesser coming to make a mark.
          best_guess = collegiate_affiliations.first
        else

          # Find the most recent college.
          best_guess = collegiate_affiliations.order('year asc').last # will pick chronologically last or latest in FB education history array
        end
      else

        # Else no 'College' affiliations. Take the last and hope they're in chronological order.
        best_guess = affiliations.last
      end

      # Assign best guess *affiliation* as primary.
      best_guess.assign_as_primary
      return best_guess.school

    else
      # Yuck.
      return School.friendly.find('spy-university')
    end
  end

  def override_school_primary(affiliation)
    affiliations.all.each do |aff|
      aff.update_attributes(is_primary: false)
    end
    affiliation.update_attributes(is_primary: true)
  end

  # Oauth.
  def self.create_with_omniauth(auth)

    # Handle varying providers json auth responses.
    case auth["provider"]
    when 'facebook'
      oauth_params = {
        email: auth["info"]["email"],
        name: auth["info"]["name"],
        password: SecureRandom.hex(13),
        # has_oauth: true, # <-- this is now handled through linked_account.rb after_create/destroy callbacks
        created_as_oauth: true,
        has_password: false
      }
    end

    # Create user instance.
    user = create!(oauth_params)

    # Create LinkedAccount instance.
    user.add_linked_account(auth)

    # Activate and return user.
    user.activate
    user
  end

  def add_linked_account(auth)
    LinkedAccount.add_for_user(self, auth)
    # self.update_attributes(has_oauth: true)
  end

  def facebook
    linked_accounts.where( :provider => "facebook" ).first
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def create_email_update_digest(new_email)
    self.email_update_token = User.new_token
    update_attribute(:email_update_digest, User.digest(email_update_token))
    update_attribute(:email_update_sent_at, Time.zone.now)
    update_attribute(:new_email_confirmed, false) # Sets (or resets) boolean to false if == 0 completed email updates or pending 1 email update
  end

  def update_confirmed_email(new_email)
    old_email = self.email
    update_attribute(:email, new_email)
    update_attribute(:new_email, old_email)
    update_attribute(:new_email_confirmed, true) # Will be true if >= 1 completed and 0 pending email updates. In this case ":new_email" will really mean "alternate_email" aka "old_email".
  end

  def has_a_new_school_email
    # Checking if user has changed their email, and that it has changed to an academic one.
    if self.new_email_confirmed? && # has changed their email
      ((Swot::is_academic? self.email) || (self.email =~ VALID_EMAIL_REGEX_EDU || VALID_EMAIL_REGEX_AC_UK)) # their new email seems academic
      return true
    else
      return false
    end
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def send_email_update_email
    UserMailer.email_update(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def email_update_expired?
    email_update_sent_at < 2.hours.ago
  end

  ############################
  ## COUNTS ##
  ############################

  # # Update counts on relations.
  # def update_school_users_count
  #   self.school.update_users_count
  # end
  # # Update counts on self.
  # def update_works_count
  #   self.update_attribute(:works_count, self.works.count)
  # end
  # def update_bookmarks_count
  #   self.update_attribute(:bookmarks_count, self.bookmarks.where(bookmarked: true).count)
  # end
  def total_upload_mass
    number_to_human_size(self.works.all.sum(:file_size))
  end

  private

    def slug_candidates
      if self.email? # <-- this will be true if the user exists.
      [
        :name,
        self.email.split("@").first,
        self.email.gsub(".edu",""),
        #if self.school.present? then [self.email.split("@").first, self.school.Institution_Name] end,
        #[self.email.split("@").first],
        [:name, :uuid]
        # [:name, :email_school_name],
        # [:email_name, :email_school_name]
      ]
      end
    end

    # Regenerates slug when user edits their name.
    def should_generate_new_friendly_id?
      name_changed? || super
    end

    # Creates a default school_id by matching user's emain domain (everything after the @)
    # against our own custom-made school_domain_slice in the Schools table OR against Swot's black-boxy intuition
        # Currently we have 3721/5391 of our schools as [is_academic: true] as cross referenced against Swot. Meaning that according to Swot we have 1670 schools that are not academic.
    def init_affiliation
      if !facebook.nil?
        Affiliation.handle(self, facebook)
      else
        Affiliation.handle(self, nil)
      end
    end

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase if self.email?
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def create_uuid
      self.uuid = SecureRandom.uuid
    end
end
