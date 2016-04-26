class SchoolSerializer < ActiveModel::Serializer
  attributes :id,
			:Institution_Name, 
			:Institution_Address, 
			:Institution_City, 
			:Institution_State, 
			:Institution_Zip, 
			:school_domain_slice
end