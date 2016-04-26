module UsersHelper
  # Returns the Gravatar for the given user.
  # def gravatar_for(user, options = { size: 80 })
  #   gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
  #   size = options[:size]
  #   gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  #   image_tag(gravatar_url, alt: user.name, class: "gravatar")
  # end

  def icon_for_provider(provider, rel_size = "medium", style = "")
  	base_icon_image_path = "oauth-icons"

  	case rel_size 
  	when "small"
  		dimension = 14
  	when "medium"
  		dimension = 20
  	when "large"
  		dimension = 50
  	end

  	case provider
  	when 'facebook'
  		image_tag "#{base_icon_image_path}/facebook-logo-circle.png", height: dimension, width: dimension, style: "#{style}"
  	end
  end

  def providers_not_connected(linked_accounts)
    available_providers = ['facebook']
    linked_accounts.all.each do |la|
      available_providers.delete(la.provider)
    end
    return available_providers
  end

  def secondary_affiliations(affiliations)
    return affiliations.where(is_primary: false)
  end

end
