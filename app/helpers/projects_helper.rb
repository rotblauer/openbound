require 'filetypeable.rb'
module ProjectsHelper

	include Filetypeable

	def project_owner? project
		logged_in? and project.user_id == current_user.id
	end

	# http://stackoverflow.com/questions/195740/how-do-you-do-relative-time-in-rails
	def to_pretty(time1, time2)
	  a = (time2 - time1).to_i

	  is_consecutive = time1 < time2 ? 'later' : 'earlier'

	  case a
	    when 0 then "simultaneously"
	    when 1 then "a second #{is_consecutive}"
	    when 2..59 then a.to_s+" seconds #{is_consecutive}"
	    when 60..119 then "a minute #{is_consecutive}" #120 = 2 minutes
	    when 120..3540 then (a/60).to_i.to_s+" minutes #{is_consecutive}"
	    when 3541..7100 then "an hour #{is_consecutive}" # 3600 = 1 hour
	    when 7101..82800 then ((a+99)/3600).to_i.to_s+" hours #{is_consecutive}"
	    when 82801..172000 then "a day #{is_consecutive}" # 86400 = 1 day
	    when 172001..518400 then ((a+800)/(60*60*24)).to_i.to_s+" days #{is_consecutive}"
	    when 518400..1036800 then "a week #{is_consecutive}"
	    else ((a+180000)/(60*60*24*7)).to_i.to_s+" weeks #{is_consecutive}"
	  end
	end


	def unique_works_by_type(project)
		works = project.works.group(["id", "source_from", "content_type"])
		works
	end


	# def time_later_in_words(time1, time2)
	# 	output = ""
	# 	# does time2 come after time1?
	# 	# this will change 'earlier' or 'later' on output
	# 	is_consecutive = time1 < time2 ? true : false

	# 	gen = TimeDifference.between(time1, time2).in_general
	# 		# => {:years=>0, :months=>0, :weeks=>0, :days=>0, :hours=>0, :minutes=>1, :seconds=>10}


	# 	# general -> specific
	# 	if (gen[:years] => 0 && gen[:months] => 0 && gen[:weeks] => 0 && gen[:days] => 0 && gen[:hours] => 0 && gen[:minutes] => 0 ) # is damn short
	# 		output << 'seconds'
	# 	elsif (gen[:years] => 0 && gen[:months] => 0 && gen[:weeks] => 0 && gen[:days] => 0 && gen[:hours] => 0 ) # is real short
	# 		output << pluralize(gen[:minutes].to_i, 'minute')
	# 	elsif (gen[:years] => 0 && gen[:months] => 0 && gen[:weeks] => 0 && gen[:days] => 0 && gen[:hours] > 0 ) # is pretty short
	# 		output << pluralize(gen[:hours].to_i, 'hour')
	# 	elsif (gen[:years] => 0 && gen[:months] => 0 && gen[:weeks] >=> 0 && gen[:days] >=> 0 && gen[:days] <=> 14)   # is medium
	# 		output << pluralize(gen[:days].to_i, 'day')
	# 	elsif (gen[:years] => 0 && gen[:months] => 0 && gen[:weeks] >=> 2  ) # is pretty long
	# 		output << pluralize(gen[:weeks].to_i, 'week')
	# 	elsif (gen[:years] => 0 && gen[:months] > 0  ) # is real long
	# 		output << pluralize(gen[:weeks].to_i, 'month')
	# 	elsif (gen[:years] > 0  ) # is damn long
	# 		output << pluralize(gen[:years].to_i, 'year')
	# 	end

	# 	case is_consecutive
	# 	when false
	# 		output << " earlier"
	# 	else
	# 		output << " later"
	# 	end

	# 	return output

	# end

end
