require 'faker'

FactoryGirl.define do

	# before :each do 
	# 	@file = 
	# end
	# Basic work. 
  factory :work do |w|
  	w.user_id 1
  	# w.document "..../public/uploads/work/document/2213/JULIA_ARDIS__FR._325_r_daction_finale.docx"
  end

  # More work. 
  factory :thesis, parent: :work do |w|
  	w.name { Faker::Lorem.sentence }

  	w.content_type 'application/msword'
  	w.file_size { rand(1000..40000) }
  	w.file_name { w.document }

	  ## This writes a fake paper in md and html form. 
	  # The research. 
	  paper_name = "Thesis"
	  paper_class = Faker::Company.name
	  paper_school = "Harvard"
	  paper_title = Faker::Hacker.say_something_smart
	  paper_subtitle = Faker::Company.catch_phrase
	  paper_snappy = Faker::Lorem.paragraph(20, 9)
	  paper_meat = Faker::Lorem.sentence(100,40)
	  paper_powerful = Faker::Lorem.paragraph(40, 40)
	  paper_theend = "The End."
	  # The writing. 
	  w.file_content_md "#{paper_name}, 
	  									 #{paper_class},  
	                     #{paper_school},
	  									 #{paper_title},  
	  									 #{paper_subtitle},  
	  									 #{paper_snappy},  
	  									 #{paper_meat},  
	  									 #{paper_powerful},  
	  									 #{paper_theend}"
	  # The publishing. 
	  w.file_content_html " <p>#{paper_name}</p>
	      <p>#{paper_class}</p>
	      <p>#{paper_school}</p>
	        <br /><br />      
	      <h1>#{paper_title}</h1>
	      <h3>#{paper_subtitle}</h3>
					<br /><br />
	      <p>#{paper_snappy}</p>
	      <p>#{paper_meat}</p>
	      <p>#{paper_powerful}</p>
					<br /><br />
	      <p><strong>#{paper_theend}</strong></p>"

	  # Makes ~half the papes anonymouse. 
	  w.anonymouse false # <-- leaves no anonymouse (all al capone); [0,1].sample <-- will do half&half if desired 
  end

end
