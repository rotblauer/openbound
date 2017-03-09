require 'counter_culture'

namespace :counter_culture do

	desc 'fix/update counter culture caches'
	task :fix_counts => :environment do 

		# puts "I am here."
		begin
			Affiliation.counter_culture_fix_counts
			# User.counter_culture_fix_counts
			Project.counter_culture_fix_counts
			Work.counter_culture_fix_counts
			Revision.counter_culture_fix_counts
			Comment.counter_culture_fix_counts
		rescue Exception => e
			puts "#{e}"
		end
	end
end