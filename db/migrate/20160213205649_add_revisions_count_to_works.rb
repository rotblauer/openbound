class AddRevisionsCountToWorks < ActiveRecord::Migration
  def up
    add_column :works, :revisions_count, :integer, :default => 0
    # Work.all.each do |work|
    #     work.revisions_count = work.revisions.count
    #     work.save
    #   end
  end
end
