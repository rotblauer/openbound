class Suggested < ActiveRecord::Base
	belongs_to :work, touch: true
	belongs_to :user

	VALID_SUGGESTION_REGEX = /\A[\w\s\d\?\.\/\,-]+\z/i # <-- allows for letters,numbers,whitespace,?,.,/,- only
	validates :suggestion, presence: true, 
                   length: { maximum: 128 }, 
                   format: { with: VALID_SUGGESTION_REGEX }
	validates :work_id, presence: true
	validates_uniqueness_of :suggestion, scope: :work_id, on: :create
	validate :unique_to_existing_tags, on: :create
	before_create :set_author_id_and_user 

	attr_accessor :suggestion_array


	def set_author_id_and_user
		self.author_id = self.work.user.id
	end

	def unique_to_existing_tags
		unless not (self.work.content_list.include?(self.suggestion) || self.work.context_list.include?(self.suggestion))
			errors.add(:suggestion, " that tag already exists!")
		end
	end

end
