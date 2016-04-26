class WorkSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :school_id, :file_content_md, :file_content_html
end
