require 'json'
class LinkedAccount < ActiveRecord::Base
  belongs_to :user

  validates :uid, presence: true
  validates :provider, presence: true

  # http://api.rubyonrails.org/classes/ActiveRecord/Base.html
  serialize :oauth_info_json 
  serialize :oauth_raw_info_json

  after_create :set_user_has_oauth, :handle_user_school_affiliation
  after_destroy :set_user_has_oauth

  def set_user_has_oauth
  	user = self.user
  	if user.linked_accounts.any?
  		user.update_attributes(has_oauth: true)
  	else 
  		user.update_attributes(has_oauth: false)
  	end
  end

  # Returns object. 
  def self.init_schema(user, auth)

	  	schema = {
	  		user_id: user.id,
		  	provider: auth["provider"],
		  	uid: auth["uid"],
        accesstoken: auth["credentials"]["token"],
		  	name: auth["info"]["name"],
		  	email: auth["info"]["email"],
		  	first_name: auth["info"]["first_name"],
		  	last_name: auth["info"]["last_name"],
		  	image_url: auth["info"]["image"],
		  	location: auth["info"]["location"],
		  	oauth_info_json: auth["info"].to_json, # .to_json
        # "{\"id\":\"147805148940843\",\"name\":\"Dick Alaacdjggjgie Greeneberg\",\"email\":\"gaxqorb_greeneberg_1456538588@tfbnw.net\",
        # \"education\":[{\"concentration\":[{\"id\":\"103966102974293\",\"name\":\"Mathematics\"}],\"school\":{\"id\":\"16279648193\",\"name\":\"Bowdoin College\"},\"type\":\"College\",\"year\":{\"id\":\"144044875610606\",\"name\":\"2011\"}}]}" 
		  	oauth_raw_info_json: auth["extra"]["raw_info"].to_json # .to_json
 		  	}

		  # Returns. 
	  	schema
  end

  def update_schema(auth)

  	schema = {
	  	name: auth["info"]["name"],
	  	email: auth["info"]["email"],
      accesstoken: auth["credentials"]["token"],
	  	first_name: auth["info"]["first_name"],
	  	last_name: auth["info"]["last_name"],
	  	image_url: auth["info"]["image"],
	  	location: auth["info"]["location"],
	  	oauth_info_json: auth["info"].to_json, #.to_json
	  	oauth_raw_info_json: auth["extra"]["raw_info"].to_json #.to_json
	  	}

	  # Returns. 
  	schema
  end

  def self.add_for_user(user, auth)
	  	self.create!(self.init_schema(user, auth))
  end

  def update_from_auth(auth)
  	self.update_attributes!(update_schema(auth))
  end

  def handle_user_school_affiliation
    # Only add an affiliation by given provider if there isn't one for the user already. 
    Affiliation.handle(self.user, self) if Affiliation.find_by(user_id: self.user.id, provider: self.provider).nil?
  end
end
