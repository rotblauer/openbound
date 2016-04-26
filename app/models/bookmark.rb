class Bookmark < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  counter_culture :user 
  counter_culture :project
  
  validates :project_id, presence: true 
  validates :user_id, presence: true
  validates :bookmarked, presence: true
  
  validates_uniqueness_of :user_id, scope: :project_id

  # after_commit :update_user_bookmarks_count
  # after_save :udpate_project_bookmarks_count

  default_scope -> { order(created_at: :desc) }

  # def update_user_bookmarks_count
  # 	self.user.update_bookmarks_count
  # end

  # def udpate_project_bookmarks_count
  #   self.project.update_bookmarked_count
  # end

  # ----------- project init ------------ #
  
  def assign_to_project
    proj_id = self.work.project.id
    self.update_attributes(project_id: proj_id)
  end
  

end
