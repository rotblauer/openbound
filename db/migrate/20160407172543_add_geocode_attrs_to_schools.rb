class AddGeocodeAttrsToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :geocode_json, :text
    add_column :schools, :geocode_lat, :float
    add_column :schools, :geocode_lng, :float
  end
end
