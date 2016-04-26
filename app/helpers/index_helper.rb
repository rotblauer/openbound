module IndexHelper

	def browser_icon_image(string)
		string.downcase!
		image_tag "browser-icon/#{string}.png", height: 14
	end

	def browser_icon(string)
		case string 
		when 'Safari','Chrome','Firefox','Facebook'
			browser_icon_image string
		when 'Chrome Mobile iOS','Chrome Mobile'
			browser_icon 'Chrome'
		when 'Mobile Safari'
			browser_icon 'Safari'
		else 
			string
		end
	end

	def device_icon(string)
		case string
		when 'Desktop'
			content_tag :span, "", class: "fa fa-desktop"
		when 'Mobile'
			content_tag :span, "", class: "fa fa-mobile"
		else  
		end
	end
end
