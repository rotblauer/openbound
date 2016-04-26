## This one was giving me flack on the eb deploy. Fuck it. 

class RemoveHtmlAndMdColumnsFromWorks < ActiveRecord::Migration
  def change
  	# remove_column :works, :markdown, :string
  	# remove_column :works, :html, :string
  end
end
