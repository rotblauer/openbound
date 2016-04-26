class AddColumnUploadMarkdownedTosToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :upload_markdowned_tos, :string
  end
end
