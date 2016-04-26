class AddColumnImpressionsCountToWork < ActiveRecord::Migration
  def change
    add_column :works, :impressions_count, :integer, :null => false, :default => 0
  end
end
