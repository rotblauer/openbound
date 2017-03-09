# This task will
## delete all the shit in public/assets
## run a local precompile for RAILS_ENV=production
##
namespace :t_minus do

	desc "prepare for liftoff"
	task :one do
		puts Time.now

		puts "Removing old precompiled public/assets..."
		# removes all old precompiled assets
		sh "rm -rf #{Rails.root}/public/assets"
		puts "Done removing old precompiled public/assets."

		puts "Precompiling for production..."
		# repopulates with freshy precompilation
		sh "bundle exec rake assets:precompile RAILS_ENV=production"
		puts "Precomp complete."

		puts Time.now
		puts "Houston, we are ready for deployment."
	end

	desc "disembark"
	task :dev do
		puts Time.now

		puts "Removing old precompiled public/assets..."
		# removes all old precompiled assets
		sh "rm -rf #{Rails.root}/public/assets"
		puts "Done removing old precompiled public/assets."

		# puts "Precompiling for production..."
		# # repopulates with freshy precompilation
		# sh "bundle exec rake assets:precompile RAILS_ENV=production"
		# puts "Precomp complete."

		puts Time.now
		puts "Houston, we are ready for development."
	end


	### PRODUCTION ###
	desc "taxi, takeoff, and stowaway"
	task :production do

		puts "PRODUCTION DEPLOY"
		start_time = Time.now
		puts start_time

		# Does assets:precompilation stuff

		puts "Removing old precompiled public/assets..."
		# removes all old precompiled assets
		sh "rm -rf #{Rails.root}/public/assets"
		puts "Done removing old precompiled public/assets."

		puts "Precompiling for production..."
		# repopulates with freshy precompilation
		sh "bundle exec rake assets:precompile RAILS_ENV=production"
		precomp_time = Time.now
		puts "Precomp complete in #{(precomp_time - start_time)/60} minutes."

		puts "Houston, we are ready for deployment."

		# Does deploy.
		deploy_start_time = Time.now
		puts "Deploying..."
		sh "cap deploy"
		deploy_end_time = Time.now
		puts "Houston, we have liftoff."
		puts "Deploy complete in #{(deploy_end_time - deploy_start_time)/60} minutes."
		# Removes everything from precompilation so development env works.

		puts "Removing those pesky production compiled assets."
		sh "rm -rf #{Rails.root}/public/assets"

		end_time = Time.now
		puts end_time

		time_required = (end_time - start_time)/60
		puts "This t_minus sequence required a total of #{time_required} minutes."

		puts "As you were."
	end

	### STAGING ###
	# same as production, except cap command env variable
	desc "taxi, takeoff, and stowaway"
	task :staging do

		puts "STAGING DEPLOY"
		start_time = Time.now
		puts start_time

		# Does assets:precompilation stuff

		puts "Removing old precompiled public/assets..."
		# removes all old precompiled assets
		sh "rm -rf #{Rails.root}/public/assets"
		puts "Done removing old precompiled public/assets."

		puts "Precompiling for production..."
		# repopulates with freshy precompilation
		sh "bundle exec rake assets:precompile RAILS_ENV=production"
		precomp_time = Time.now
		puts "Precomp complete in #{(precomp_time - start_time)/60} minutes."

		puts "Houston, we are ready for deployment."

		# Does deploy.
		deploy_start_time = Time.now
		puts "Deploying..."
		sh "RUBBER_ENV=staging cap staging deploy"
		deploy_end_time = Time.now
		puts "Houston, we have liftoff."
		puts "Deploy complete in #{(deploy_end_time - deploy_start_time)/60} minutes."
		# Removes everything from precompilation so development env works.

		puts "Removing those pesky production compiled assets."
		sh "rm -rf #{Rails.root}/public/assets"

		end_time = Time.now
		puts end_time

		time_required = (end_time - start_time)/60
		puts "This t_minus sequence required a total of #{time_required} minutes."

		puts "As you were."
	end

end
