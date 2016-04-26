class Revision < ActiveRecord::Base
  belongs_to :work
  belongs_to :project

  counter_culture :work
  counter_culture :project

  before_save :limit_revision_history

  # A work is only allowed to have 20 revisions, say. 
  def limit_revision_history
  	work = self.work
  	revisions = work.revisions.all
  	if revisions.count == 20
  		revisions.first.destroy
  	end
  end


end
