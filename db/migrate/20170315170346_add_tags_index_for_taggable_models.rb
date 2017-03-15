class AddTagsIndexForTaggableModels < ActiveRecord::Migration
  def change
    add_index :projects, :tags, using: 'gin'
    add_index :works, :tags, using: 'gin'
  end
end
