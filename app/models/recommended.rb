class Recommended < ActiveRecord::Base
	belongs_to :user
	belongs_to :work
	
	validates :work_id, presence: true 
	validates :user_id, presence: true

	validates_uniqueness_of :user_id, scope: :work_id

	default_scope -> { order(created_at: :desc) }

	
end
