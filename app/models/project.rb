class Project < ActiveRecord::Base

  ############################################
  ## Associations
  ############################################

  belongs_to :user
  belongs_to :school

  counter_culture :user
  counter_culture :school

  # dependent: destroy for works and/or diffs causes `can't modify frozen hash` error,
  # so it's handled manually in before_destroy :destroy_all_works
  has_many :works#, dependent: :destroy
  has_many :revisions
  has_many :diffs#, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :comments, dependent: :destroy


  ############################################
  ## Gem integrations
  ############################################

  is_impressionable counter_cache: true, unique: :session_hash
  acts_as_taggable_array_on :tags

  extend FriendlyId
    friendly_id :slug_candidates, use: :slugged

  # Sunspot Solr indexes
    # text is searchable 'normally', ie search bar query
    # string is facetable, ie filter by tags
    # time is sortable, ie IDK
    # integer, boolean is filterable, ie project any_of do / :with()

  # accepts_nested_attributes_for :works, allow_destroy: true, :reject_if => proc { |attributes| attributes['file_content_md'].blank? }

  # searchable do
  #   integer :id
  #   text :name, boost: 3.0
  #   text :description, boost: 3.0

  #   # string :content_list, multiple: true
  #   # text :content_list, boost: 1.5 # <-- repeated as text to allow for querying
  #   # string :context_list, multiple: true
  #   # text :context_list, boost: 1.5 # <-- repeated as text to allow for querying

  #   text :author_name
  #   time :updated_at
  #   time :created_at
  #   # integer :school_id
  #   string :school_name # <-- un-removed because dirties "search works" (ie query="Minnesota" would return works from UofM, not works pertaining to Minnesota)
  #   #text :school_name
  #   string :school_id
  #   string :user_id # string, really?
  #   boolean :anonymouse

  #   text :works do
  #     # http://stackoverflow.com/questions/3244588/how-to-map-more-than-one-attribute-with-activerecord
  #     works.map{|f| [f.file_content_text, f.name]}
  #   end
  # end


  ############################################
  ## Validations
  ############################################

  validates :user_id, presence: true
  validates :school_id, presence: true
  validates :recent_work_id, presence: true


  ############################################
  ## Callbacks
  ############################################

  # TODO: fix infinite stack for after_update_callback
  before_save :set_author_name
  after_save :set_works_project_name
  #, :has_some_works_or_destroy
  #   def has_some_works_or_destroy
  #     if self.works.count == 0
  #       self.destroy
  #     end
  #   end
  before_destroy :delete_tags, prepend: true
  before_destroy :destroy_all_works
    def destroy_all_works
      works.all.each do |w|
        w.destroy
      end
    end


  ############################################
  ## Self definers
  ############################################

  # def update_bookmarked_count
  #   self.update_attribute(:bookmarked_count, self.bookmarks.where(bookmarked: true).count)
  # end

  # # returns Work
  def most_recent_work
    Work.find(recent_work_id)
  end

  # def update_works_count
  # 	count = self.works.count
  #   self.update_attributes(works_count: count)
  # end

  ############################################
  ## Initial install
  ############################################

  # ----------- init Project tags ------------ #

  def sync_tags_to_children_works
    works = works.all
    works.each do |work|
      self.tags.concat(work.tags)
    end
    self.save
  end

  # ----------- init impressions inheritance ------------ #
  def collect_impressions_init
    children_view_total = works.sum(:impressions_count)
    self.update_columns(impressions_count: children_view_total)
  end

  def self.search(query:nil,
                  tags:[],
                  schools:[],
                  id:nil,
                  page:1,
                  per_page:24,
                  school_id:nil)

    q = all
    q = q.basic_search(query) if !query.nil?
    # q = q.where.contains(:tags => tags) if tags.any?
    q = q.with_any_tags(tags) if tags.any? #q.with_all_tags is also supported by the actastaggablearrayon gem
    q = q.where(:school_name => schools) if schools.any?

    # id = id.to_i if !id.nil?
    q = q.where("id < ?", id.to_i) if !id.nil? # id.is_a? Numeric

    # school_id = school_id.to_i if !school_id.nil?
    q = q.where(school_id: school_id.to_i) if !school_id.nil?

    return q.order(created_at: :desc)
            .limit(per_page)
            .offset(( page-1 )*per_page)
  end


  private
  	# Prioritizes candidates for slugging; references name_or_file_name method below.
  	def slug_candidates
  		if name? # this could change if name changes
  			name
  		else
  	  	SecureRandom.uuid
  	  end
  	end

    # Sets author_name, which reflects either true creator's name or penname, depending on user's privacy choices.
    def set_author_name
      # Handles toggling between fake and real names (at edit)
      if attribute_changed?(:anonymouse)
        if anonymouse?
          self.author_name = Faker::Name.name

        else
          self.author_name = self.user.name

        end
      end
      # Handles
      if !anonymouse?
        self.author_name = self.user.name
      end
    end

    def set_works_project_name
      if attribute_changed?(:name)
        works.all.each do |work|
          work.update_attributes(project_name: name)
        end
      end
    end

    def delete_tags
      tags = []
    end

end
