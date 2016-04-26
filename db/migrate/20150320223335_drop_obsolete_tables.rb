class DropObsoleteTables < ActiveRecord::Migration
	
  def up
  	if ActiveRecord::Base.connection.table_exists? 'comment_hierarchies'
  		drop_table :comment_hierarchies
  	end
  	if ActiveRecord::Base.connection.table_exists? 'average_caches'
  		drop_table :average_caches
  	end
  	if ActiveRecord::Base.connection.table_exists? 'folders'
  		drop_table :folders
  	end
  	if ActiveRecord::Base.connection.table_exists? 'rates'
  		drop_table :rates
  	end
  	if ActiveRecord::Base.connection.table_exists? 'rating_caches'
  		drop_table :rating_caches
  	end
  	if ActiveRecord::Base.connection.table_exists? 'uploads'
  		drop_table :uploads
  	end
    if ActiveRecord::Base.connection.table_exists? 'overall_averages'
      drop_table :overall_averages
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
