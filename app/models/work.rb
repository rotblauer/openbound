# encoding: utf-8
require 'assets/wdiff.rb'
require 'html/pipeline'
require 'redcarpet'
require 'redcarpet/render_strip'
require 'pandoc-ruby'
require 'converter-machine.rb'
require 'filetypeable.rb'
class Work < ActiveRecord::Base
  include Rails.application.routes.url_helpers # <-- this might be for using Work.document_url for retrieving given work's associated document
  include ConverterMachine
  include Filetypeable
  ############################################
  ## Associations
  ############################################

  belongs_to :user
  belongs_to :school
  belongs_to :project, touch: true

  counter_culture :user
  counter_culture :school
  counter_culture :project

  has_many :comments, dependent: :destroy
  has_many :gradients, dependent: :destroy
  # has_many :bookmarks, dependent: :destroy # --> projects
  has_many :suggesteds, dependent: :destroy
  has_many :recommendeds, dependent: :destroy # --> projects
  has_many :revisions, dependent: :destroy


  ############################################
  ## Gem integrations
  ############################################

  is_impressionable counter_cache: true, unique: :session_hash # column: impressions_count (int)

  # FriendlyID for pretty URLs
  extend FriendlyId
    friendly_id :slug_candidates, use: :slugged # <-- def :slug_candidates in private

  # Humps ahead.
  mount_uploader :document, DocumentUploader

  # Solr search method attributes
  # note the difference between `text` and `string` -- `text` is searchable normally (query), the other can run facets
  # searchable do
  #   integer :id
  #   text :name, boost: 3.0
  #   text :description, boost: 3.0
  #   text :document
  #   text :file_name, stored: true

  #   # string :content_list, multiple: true
  #   # text :content_list, boost: 1.5 # <-- repeated as text to allow for querying
  #   # string :context_list, multiple: true
  #   # text :context_list, boost: 1.5 # <-- repeated as text to allow for querying

  #   ### Using exclusively plain text for search indexing. Avoids query results for 'span', 'head', 'meta', 'style'
  #     # text :file_content_md, boost: 2.0
  #     # text :file_content_html, boost: 2.0
  #   text :file_content_text, boost: 2.0

  #   text :author_name
  #   time :updated_at
  #   time :created_at
  #   # integer :school_id
  #   string :school_name # <-- un-removed because dirties "search works" (ie query="Minnesota" would return works from UofM, not works pertaining to Minnesota)
  #   #text :school_name
  #   string :school_id
  #   string :user_id
  #   boolean :anonymouse

  #   boolean :is_latest_version
  #   integer :project_id
  #   text :project_name, boost: 3.0
  # end


  ############################################
  ## Validations
  ############################################

  validates :user_id, presence: true

  # Skips validation for document presence in test env.
  if !Rails.env.test?
    validates :document,
      file_size: { less_than_or_equal_to: 5.megabytes, message: " must be less than 5 megabytes!" } # <-- comment all document validation while seeding
  end

  # Make sure there is some work uploaded - either a file or file content.
  validate :has_some_work_shit
    def has_some_work_shit
      if [self.document, self.remote_document_url, self.file_content_html, self.file_content_md, self.file_content_text].reject(&:blank?).size == 0
        errors[:base] << ("Please choose a document to upload.")
      end
    end

  # See private methods.
  validate :user_has_reasonable_total_upload_mass, on: [:create, :update]
  validate :description_is_short, on: [:create, :update]

  ############################################
  ## Callbacks
  ############################################

  # ----------- Skip gerrymandering ------------ #



  # ----------- Create ------------ #

  # Self grooming. (See privates).
  before_create :set_school_name, :set_anonymity_before_create #, :get_slug_preview#, :set_slug_before_create #, :set_impressions_count

  # Yes, order matter. At least for set_name.
  after_create :set_name, :init_textuals, :init_or_update_project, :set_as_most_recent_work, :unset_previous_latest_version

    def set_name
      self.update_attribute(:name, self.file_name) if !self.name.present?
    end
    def set_as_most_recent_work
      proj = self.project
      proj.update_attributes(recent_work_id: self.id)
    end
    def unset_previous_latest_version # and setting latest version to current happens in :project_update
      proj = self.project
      # WIP: this could be more efficient
      proj.works.reverse[1..-1].each do |work| # just to be safe ** note `reverse`
        work.update_attributes(is_latest_version: false)
      end
      self.update_attribute(:is_latest_version, true)
    end

  before_save :update_upload_attributes, :set_author_name

  # ----------- Update ------------ #

  after_update :update_if_file_content_md_changed, :update_diffs_if_any, :save_revision
    def update_diffs_if_any
      unless self.project.works_count == 1
        make_diffs # if self.file_content_md_changed?
      end
    end
    def update_if_file_content_md_changed

      puts "self.file_content_md_changed? => #{self.file_content_md_changed?}"

      update_textuals if self.file_content_md_changed? # This should not error for images.

    end
    def save_revision
      new_revision = self.revisions.new(
          project_id: self.project.id,
          data: self.attributes.to_json
        )
      if new_revision.save
        puts "************ AWESOME. Revision saved. ****************"
      else
        puts "************ BOOOOOO. Revision not saved :-( ****************"
      end
    end


  # ----------- Destroy ------------ #

  before_destroy :delete_tags, prepend: true

  # Project#before_destroy :destroy_all_works call this by destroying a work(s) individually
  after_destroy :delegate_latest_version, :remove_related_diffs, :destroy_project_no_more_works
    def delegate_latest_version
      proj = self.project
      puts "project frozen? #{proj.frozen?}"
      unless proj.frozen? # proj will be frozen if it's being destroyed
        # if !proj.works[-1].nil?
        #   runner_up = proj.works.last # should be second to last work
        # else # works[-2] IS nil, meaning only one work left
        #   runner_up = proj.first # if only one remaining work
        # end
        runner_up = proj.works.last # Can choose .last because _the deleted work no longer belongs to the project_, apparently.
        proj.update_attributes!(recent_work_id: runner_up.id) if !runner_up.nil? # update project work pointer attr
        runner_up.update_attributes!(is_latest_version: true) if !runner_up.nil? # update work is_latest_version attr
      else
        puts "-----------------------> Project was frozeeeen. delegate_latest_version probably didn't work"
      end
    end
    # http://stackoverflow.com/questions/3639656/activerecord-or-query
    def remove_related_diffs
      s_id = self.id
      # Foo.where('foo= ? OR bar= ?', 'bar', 'bar')
      diffs = Diff.where('work1 = ? OR work2 = ?', s_id, s_id)
      puts "diffs frozen? #{diffs.frozen?}"
      unless diffs.frozen?
        diffs.all.each { |d| d.destroy } if diffs.any?
      end
    end
    def destroy_project_no_more_works
      proj = self.project
      if proj.works.count == 0
        proj.destroy
      end
    end

  # This is one way to extract the image pages *locally* with Docsplit.
  # require 'split'
  # after_create :extract_first_page_images, if: :is_extractable? #, on: :create
  # extract :to => :thumbs, :sizes => { :large => "300x", :medium => "500x" } #, if: :pdf?, on: :create

  # ----------- Commit ------------ #

  # Parent works_count
  # after_commit :update_user_works_count, on: [:create, :destroy]
  # after_commit :update_school_works_count, on: [:create, :destroy]
  # after_commit :update_project_works_count, on: [:create, :destroy]

  def self.search(query:nil, tags:[], schools:[], id:nil, page:1, per_page:24)
    # puts "query: #{query}"
    # puts "tags: #{tags}"
    # puts "school: #{school_name}"
    # puts "id: #{id}"
    # puts "per_page: #{per_page}"
    q = self.all
    q = q.basic_search(query) if !query.nil?
    q = q.where.contains(:tags => tags) if tags.any?
    q = q.where(:school_name => schools) if schools.any?

    id = id.to_i if !id.nil?
    q = q.where("id < ?", id) if id.is_a? Numeric

    return q.order(created_at: :desc)
            .limit(per_page)
            .offset(( page-1 )*per_page)
            # .order_by(:created_at, :desc)
  end

  ############################################
  ## Callback definitions
  ############################################

  # May convert html -> markdown & plain.
  # May convert md -> html & plain.
  # May convert plain -> html & markdown.
  def init_textuals
    # Prioritize markdown.
    if self.file_content_md
      markdown_to_html_and_text
    elsif self.file_content_html
      clean_html if self.source_from == 'google_drive'
      html_to_markdown
      html_to_plain
    elsif self.file_content_text
      text_to_md
      text_to_html
    elsif self.image?
      # do nothing
    else
      errors.add("There is no textual content for work id: #{self.id}")
    end
  end

  # Will _always_ be coming from changed markdown.
  def update_textuals
    # FIXME: this will remove all classes from Google Drive, which identify versions (I think) and styling.
    # Fuck it.
    markdown_to_html_and_text
  end

  # When coming from google (w2m and the HTML::Pipeline::MarkdownFilter don't leave extraneous tags coming from DocumentUploader)
  ## I turned keep CSS on.
  def clean_html
      cleaned = ConverterMachine.clean_html(self) # => {html: clean html, css: Nokogiri extracted <style>...</style>}
      self.update_attributes!(file_content_html: cleaned[:html], file_content_css: cleaned[:css])
  end

  # Convert html to markdown unless DocumentUploader has already taken care of that (ie if the upload is coming from Google Drive)
  def html_to_markdown
    html_decoded = ConverterMachine.html_markdown(self)

    # Update the work.
    unless self.update_attributes!(file_content_md: html_decoded)
      errors.add("There was an error updating MD for work id: #{self.id}")
    end
  end

  def html_to_plain
    plain = ConverterMachine.html_text(self)

    # Update the work.
    unless self.update_attributes!(file_content_text: plain)
      errors.add("There was an error updating TEXT for work id: #{self.id}")
    end
  end

  def text_to_md
  	# Remember, update_columns skips callbacks and validations.
    self.update_columns(file_content_md: self.file_content_text)
  end

  def text_to_html
    # TODO: make this better.
    self.update_column(:file_content_html, self.file_content_text)
  end

  def markdown_to_html_and_text
  	markdown = ConverterMachine.markdown_html(self)
    plain = ConverterMachine.markdown_text(self)
    unless self.update_columns(file_content_html: markdown, file_content_text: plain)
  	 errors.add("There was an error updating MARKDOWN AND TEXT for work id: #{self.id}")
    end
  end

  ############################################
  ## re: Documents and file_types
  ############################################



  # Document upload helper thing
  def document_attachment
    "#{Rails.root}/uploads/#{document.url}"
  end

  def document_basename
    return self.file_name.chomp('.pdf') # FIXME: this does not look good.
  end

  ############################################
  ## COUNT UPDATERS
  ############################################

  # Count on relations.
  # def update_user_works_count
  #   self.user.update_works_count
  # end
  # def update_school_works_count
  #   self.school.update_works_count
  # end
  # def update_project_works_count
  #   self.project.update_works_count if !self.project.frozen?
  # end

  # Update counts on self.
  # def update_gradient_count
  #   self.update_attribute(:gradient_count, self.gradients.count)
  # end
  # def update_gradient_averages
  #   self.update_attribute(:gradient_average, self.gradients.average(:grad))
  #   self.update_attribute(:gradient_average_rgb, self.gradient_average.round)
  # end
  # def update_bookmarked_count
  #   self.update_attribute(:bookmarked_count, self.bookmarks.where(bookmarked: true).count)
  # end

  # returns ratio of relative popularness, like .76 popular
  # then will multiply this by 255 for rgb color in gradient-impressions part (the square)
  def popularity_contest
    @popular = Work.maximum(:impressions_count).to_f
    n = 1 - self.impressions_count.fdiv(@popular).round(2)
    return (n*255).round
  end

  ############################################
  ## Integrate with Projects
  ############################################

  # ----------- Initial ------------ #

  # assign each existing work to a new project
    # that project should be owned by the work's user
    # that project should be associated to the work's school
    # that project should inherit name from work
    # that project should inherit file_content_<type>s from work
    # that project should increment works_count++
    # that project should assign recent_work_id from self.id

  # called as:
    # Work.all.each do |work|
    #   work.assign_to_project
    # end
  def assign_to_project
    da_user = self.user # get user
    if self.project == nil
      new_project = da_user.projects.build(

          # user_id: self.id, # handled through build method
          school_id: self.school_id,
          name: self.name,

          file_content_md: self.file_content_md,
          file_content_html: self.file_content_html,
          file_content_text: self.file_content_text,

          works_count: 1,
          recent_work_id: self.id,

          anonymouse: self.anonymouse,
          author_name: self.author_name,
          school_name: self.school_name,

          impressions_count: self.impressions_count,
          bookmarks_count: self.bookmarks_count

        )

      if new_project.save
        self.update_attributes(project_id: new_project.id, is_latest_version: true, project_name: self.name)
        puts "Successfully saved " + new_project.name.to_s
      else
        puts "Error saving " + self.name + ", id: " + self.id.to_s
      end

    # this should only be necessary in development scenario
    else
      puts "Project id: " + self.project.id.to_s + " already exists for this work id: " + self.id.to_s
    end

  end


  # ----------- Eternal ------------ #

  def is_original?
    return self.project.nil?
  end

  def init_or_update_project # after_create
    if self.is_original?
      init_project
      # set_as_latest_version
    else
      # find next-newest neighbor and update his is_latest_version attr to false
      # Work.find(self.project.recent_work_id).unset_as_latest_version
      update_project
      make_diffs
      # set_as_latest_version # sets self's attrs is_latest_version:true
    end
    # self.project.set_most_recent_work(self.id)
  end

  ## if creating original (un-projected/versioned) work
  def init_project
    da_user = self.user
    new_project = da_user.projects.build(
      # user_id: self.id, # handled through build method
      school_id: self.school_id, # merged from user.school.Institution_ID
      name: self.name, # take on name of work

      file_content_md: self.file_content_md, # these are of most recent, will be replaced as versions are added
      file_content_html: self.file_content_html,
      file_content_text: self.file_content_text,

      works_count: 1, # is first work
      recent_work_id: self.id, # as original work

      anonymouse: self.anonymouse, # and work gets this from user
      author_name: self.author_name, # ditto
      school_name: self.school_name,
      )

    if new_project.save
      self.update_attributes(project_id: new_project.id, is_latest_version: true, project_name: self.name)
    else
      errors[:base] << ("There was an error versioning this work.")
    end
  end

  def update_project
    project = self.project
    project.update_attributes(
      recent_work_id: self.id,

      file_content_md: self.file_content_md, # these are of most recent, will be replaced as versions are added
      file_content_html: self.file_content_html,
      file_content_text: self.file_content_text,

      updated_at: Time.now
      )
    self.update_attributes(is_latest_version: true)
  end

  # if the work is added to an existing project, diff the work with all of its neighbors
  def make_diffs
    # get array of all works belonging to project except self
    neighbors = []
    self.project.works.all.each do |work|
      neighbors.push(work.id)
    end
    # remove current work.id so have the *other* neighbors
    neighbors.delete(self.id)
    neighbors.each do |neighbor| # neighbor => work id
      generate_diff(neighbor, self.id)
    end
  end

  # this should be Generic
  # @workA <- any work id
  # @workB <- any work id
  # (wA and wB will be sorted lowest, highest :: earlier, latest)
  def generate_diff wA, wB

    puts "---------------------------------> generating diff for #{wA} and #{wB}"
    # sort by magnitude of id
    # returns w1 has earlier id than w2
    wA < wB ? w1id = wA : w1id = wB
    wA < wB ? w2id = wB : w2id = wA

    # get refs to whole works
    w1 = Work.find(w1id)
    w2 = Work.find(w2id)

    # check they belong to same project
    errors.add(:project, "projects don't match") unless w1.project_id == w2.project_id

    project = Project.find(w2.project_id) # same as w1


    # ----------- make diffs ------------ #

    # set values to diff from neighbord
    w1_md = w1.file_content_md.force_encoding("UTF-8") if !w1.file_content_md.nil?
    w1_html = w1.file_content_html.force_encoding("UTF-8") if !w1.file_content_html.nil?
    w1_text = w1.file_content_text.force_encoding("UTF-8") if !w1.file_content_text.nil?

    # **note** self.file_content_md is coming from ReverseMarkdown now, instead of PandocRuby
    diff_md_val = Diffy::Diff.new(w1_md ,w2.file_content_md).to_s
    diff_html_val = Diffy::Diff.new(w1_md ,w2.file_content_md).to_s(:html)
    diff_text_val = Diffy::Diff.new(w1_text ,w2.file_content_text).to_s

    ### ALWAYS DIFF INTO :HTML FORMAT SO WE CAN DISPLAY IT NEATLY.
    ### ALWAYS DIFF !EMPTY RIGHT/LEFT
    diff_left_val = Diffy::SplitDiff.new(w1_md ,w2.file_content_md, :format => :html, :allow_empty_diff => false).left if !w1_md.nil?
    diff_right_val = Diffy::SplitDiff.new(w1_md ,w2.file_content_md, :format => :html, :allow_empty_diff => false).right if !w1_md.nil?

    # _text diffs for pdfs and plain text docs
    diff_left_text_val = Diffy::SplitDiff.new(w1_text ,w2.file_content_text, :format => :html, :allow_empty_diff => false).left if !w1_text.nil?
    diff_right_text_val = Diffy::SplitDiff.new(w1_text ,w2.file_content_text, :format => :html, :allow_empty_diff => false).right if !w1_text.nil?

    # ** .scrub! ensures we don't get any fucked up character encoding errors from mysql2
    # if !diff_md_val.nil? ensures we're dealing with a diffable doc (ie not a picture)
    diff_md_val.force_encoding("UTF-8").scrub! if !diff_md_val.nil? #.encode!('UTF-8', :invalid => :replace, :undef => :replace, :replace => '')!diff_md_val.nil?
    diff_html_val.force_encoding("UTF-8").scrub! if !diff_html_val.nil?
    diff_text_val.force_encoding("UTF-8").scrub! if !diff_text_val.nil?

    diff_left_val.force_encoding("UTF-8").scrub! if !diff_left_val.nil?
    diff_right_val.force_encoding("UTF-8").scrub! if !diff_right_val.nil?

    diff_left_text_val.force_encoding("UTF-8").scrub! if !diff_left_val.nil?
    diff_right_text_val.force_encoding("UTF-8").scrub! if !diff_right_val.nil?

    # ----------- update or create diff ------------ #

    # update_or_create for, well, updating or creating
    diff = Diff.where(project_id: project.id, work1: w1id, work2: w2id).first_or_create
    diff.update!(
      diff_md: diff_md_val,
      diff_html: diff_html_val,
      diff_text: diff_text_val,
      left: diff_left_val,
      right: diff_right_val,
      left_text: diff_left_text_val,
      right_text: diff_right_text_val
      )

  end


  private

    def description_is_short
      if self.description.present?
      unless self.description.length < 141
        errors.add(:description, " keep it short! No more than 140 characters.")
      end
      end
    end

    def user_has_reasonable_total_upload_mass
      unless self.user.works.all.sum(:file_size) < 100.megabytes
        errors.add(:document, " is too much! You have reached your upload limit of 100MB!")
      end
    end

    # Prioritizes candidates for slugging; references name_or_file_name method below.
    def slug_candidates
      SecureRandom.uuid
    end

    # Saves upload content_type and file_size as attributes.
    def update_upload_attributes
      if document.present? && document_changed?
        self.content_type = document.file.content_type
        self.file_size = document.file.size
        self.file_name = File.basename(document.url)
      end
    end

    # Sets work's associated school name before create.
    def set_school_name
      self.school_name = self.user.school_primary.Institution_Name
      # also set school id
      self.school_id = self.user.school_primary.id
    end

    def set_anonymity_before_create
      if self.user.superman
        self.author_name = Faker::Name.name
        self.anonymouse = true
      end
    end

    # Sets author_name, which reflects either true creator's name or penname, depending on user's privacy choices.
    def set_author_name
      # Handles toggling between fake and real names (at edit)
      if anonymouse_changed?
        if self.anonymouse
          self.author_name = Faker::Name.name
        else
          self.author_name = self.user.name
        end
      end
      # Handles
      if !self.anonymouse
        self.author_name = self.user.name
      end
    end

    def delete_tags
      self.tags = []
    end
end
