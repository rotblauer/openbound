class AddColumnRemoteDocumentUrlToWorks < ActiveRecord::Migration
  def change
    add_column :works, :remote_document_url, :string
  end
end
