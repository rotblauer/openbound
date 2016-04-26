class UpdateCacheCounts < ActiveRecord::Migration
  def change

  	# School.all.each do |school|
  	# 	projects_c = school.projects.count
   #    puts "Updating #{school.Institution_Name} projects_count => #{projects_c}"
  	# 	school.update_attributes(projects_count: projects_c)
  	# end

  	# User.all.each do |user|
  	# 	projects_c = user.projects.count
  	# 	comments_c = user.comments.count
   #    puts "Updating #{user.name} project_count => #{projects_c}, comments_count => #{comments_c}"
  	# 	user.update_attributes(
  	# 		projects_count: projects_c,
  	# 		comments_count: comments_c
  	# 		)
  	# end

  	# Project.all.each do |project|
  	# 	diffs_c = project.diffs.count
  	# 	comments_c = project.comments.count
  	# 	revisions_c = project.revisions.count
   #    puts "Updating #{project.name}"
   #      puts "diffs_count => #{diffs_c}"
   #      puts "comments_count => #{revisions_c}"
   #      puts "revisions_count => #{revisions_c}"
  	# 	project.update_attributes(
  	# 		diffs_count: diffs_c,
  	# 		comments_count: comments_c,
  	# 		revisions_count: revisions_c
  	# 		)
  	# end

  	# Work.all.each do |work|
  	# 	comments_c = work.comments.count
   #    puts "Updating #{work.name || work.file_name} comments_count => #{comments_c}"
  	# 	work.update_attributes(comments_count: comments_c)
  	# end
  	
  end
end
