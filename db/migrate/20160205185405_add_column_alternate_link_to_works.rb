class AddColumnAlternateLinkToWorks < ActiveRecord::Migration
  def change
    add_column :works, :alternate_link, :string
  end
end
