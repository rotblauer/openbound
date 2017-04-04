class Comment < ActiveRecord::Base

	belongs_to :user
	belongs_to :project
	belongs_to :work

  counter_culture :user
  counter_culture :project
  counter_culture :work

  validates :body, presence: true
  validates :work_id, presence: true
  validates :user_id, presence: true
  validates :project_id, presence: true

  include PublicActivity::Model
  tracked

  # is this in use?? possibly so. same task could possibly be accomplished by the controller@index
  # acts_as_tree order: 'created_at DESC'
  default_scope -> { order(created_at: :asc) }

  # ----------- init project ------------ #
  def add_project_id
    work = self.work
    project = work.project
    self.update_attributes(project_id: project.id)
  end

end
