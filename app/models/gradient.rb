class Gradient < ActiveRecord::Base
  belongs_to :user
  belongs_to :work 

  # "grad" is the column name for the 'grade value (currently 0-255)'
  validates :work_id, presence: true 
  validates :user_id, presence: true
  validates :grad, presence: true

  validates_uniqueness_of :user_id, scope: :work_id

  after_commit :update_work_gradient_count
  after_save :update_work_gradient_average

  def update_work_gradient_count
  	self.work.update_gradient_count
  end
  def update_work_gradient_average
    self.work.update_gradient_averages
  end

end
