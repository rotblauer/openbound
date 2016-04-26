class AddDocumentToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :document, :string
  end
end
