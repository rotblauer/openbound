# require 'user_agent'
module ApplicationHelper

	# Disable layout elements. 
	# 
	# 
	@bigger_partials = false
	
	def disable_nav # (For start page.)
	  @disable_nav = true
	end
	def disable_please_sign_up # (For signin page.)
	  @disable_please_sign_up = true
	end
	def disable_footer
	  @disable_footer = true
	end
	def disabled_on_start_page
	  @disable_nav = true
	  @disable_please_sign_up = true
	  @disable_footer = true
	end
	def disable_base_upload_forms
		@disable_base_upload_forms = true
	end

	# Octicon code helper.
	# https://github.com/github/octicons
	def octicon(code)
	  content_tag :span, '', :class => "octicon octicon-#{code.to_s.dasherize}"
	end
	def octicon_mega(code) # mega, for 32px+ 
	  content_tag :span, '', :class => "octicon-mega octicon-#{code.to_s.dasherize}"
	end

	

	
end
