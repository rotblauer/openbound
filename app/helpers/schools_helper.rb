module SchoolsHelper

	include ActsAsTaggableOn::TagsHelper

	# Favicon for school instance.
	def favicon_for(school, width, height, style)
		# don't use a favicon if the work is associate with Spy University
		if false # school == School.friendly.find('spy-university')
			#return ""
		elsif !school.favicon.blank?
			image_tag(school.favicon_url, width: width, height: height, style: style)

		# images are saved to S3 on production and staging
		elsif !Rails.env.development? #!Rails.env.production?
			image_tag(school.favicon_url, width: width, height: height, style: style)

		elsif school.Institution_Web_Address
			source = "http://www.google.com/s2/favicons?domain="+school.Institution_Web_Address
			image_tag source, width: width, height: height, style: style
			# return raw '<img height="'+height.to_s+'" width="'+width.to_s+'" src="'+source.to_s+'" style="'+style+'"></img>'.html_safe
		else
			image_tag(school.favicon_url, width: width, height: height, style: style)
		end
	end

	# Return tags per school by joining associated works table.
	# Args: school instance, first(number) of tag counts desired
	#
	#
	def tag_count_hash(school, number)
		school_tags_with_count = Hash.new
		school.projects.tag_counts_on(:tags).each do |tag|
	 		school_tags_with_count["#{tag.name}"] = tag.joins("INNER JOIN projects ON taggings.taggable_id = projects.id").where("projects.school_id = #{school.id}").count
		end
		return school_tags_with_count.sort_by {|k,v| v}.reverse.first(number)
	end

	def content_count_hash(school, number)
		school_tags_with_count = Hash.new
		school.projects.tag_counts_on(:contents).each do |tag|
	 		school_tags_with_count["#{tag.name}"] = tag.taggings.joins("INNER JOIN projects ON taggings.taggable_id = projects.id").where("projects.school_id = #{school.id}").count
		end
		return school_tags_with_count.sort_by {|k,v| v}.reverse.first(number)
	end


	# Top tags charts for schools, by tag and by content.
	#
	def tag_chart(tag_count_hash)

		tag_categories = []
			tag_count_hash.each do |k,v|
				tag_categories.push(k)
			end

		tag_values = []
			tag_count_hash.each do |k,v|
				tag_values.push(-1*v)
			end

		ceiling = tag_values.max

		tag_chart = LazyHighCharts::HighChart.new('graph') do |f|
			f.title({ :text => 'Top Department Tags', :style => { :color => '#519ed6'}})
			f.xAxis [
				{ :categories => tag_categories,
					:gridLineColor => '#FFFFFF',
					:minorGridLineColor => '#FFFFFF',
					:tickColor => '#FFFFFF',
					:minorTickColor => '#FFFFFF',
					:lineColor => '#FFFFFF'
				}
			]
			f.yAxis(
							 :gridLineColor => '#FFFFFF',
							 :minorGridLineColor => '#FFFFFF',
							 :tickColor => '#FFFFFF',
							 :minorTickColor => '#FFFFFF',
							 :lineColor => '#FFFFFF',
							 :ceiling => ceiling,
							 :title => { :text => nil },
							 :allowDecimals => false,
							 :labels => { :enabled => false }
							)
			f.series(:name => 'Contexts', :xAxis => 0, :data => tag_count_hash)
			f.chart(:defaultSeriesType=> 'bar', :height => 200 )
			f.plot_options( {:bar => {:color => '#519ed6'}} )
			f.legend(:enabled => false)
		end
		return high_chart('tag_chart', tag_chart)
	end

	def content_chart(content_count_hash)

		content_categories = []
			content_count_hash.reverse.each do |k,v|
				content_categories.push(k)
			end

		content_values = []
			content_count_hash.reverse.each do |k,v|
				content_values.push(v)
			end

		ceiling = content_values.max

		content_chart = LazyHighCharts::HighChart.new('graph') do |f|
			f.title({ :text => 'Top Subject Tags', :style => {:color => '#9bc8e8'}})
			f.xAxis [
				{ :categories => content_categories,
					:reversed => false,
					:gridLineColor => '#FFFFFF',
					:minorGridLineColor => '#FFFFFF',
					:tickColor => '#FFFFFF',
					:minorTickColor => '#FFFFFF',
					:lineColor => '#FFFFFF'
				}
			]
			f.yAxis(
							 :gridLineColor => '#FFFFFF',
							 :minorGridLineColor => '#FFFFFF',
							 :tickColor => '#FFFFFF',
							 :minorTickColor => '#FFFFFF',
							 :lineColor => '#FFFFFF',
							 :ceiling => ceiling,
							 :title => { :text => nil },
							 :allowDecimals => false,
							 :labels => { :enabled => false }
							)
			f.series(:name => 'Contexts', :xAxis => 0, :data => content_count_hash.reverse)
			f.chart(:defaultSeriesType=> 'bar', :height => 200 )
			f.plot_options( {:bar => {:color => '#9bc8e8'}} )
			f.legend(:enabled => false)
		end
		return high_chart('content_chart', content_chart)
	end
end
