require 'test_helper'

class WorksWorkingTest < ActionDispatch::IntegrationTest

	def setup
		@sue = users(:Isaac)
		log_in_as(@sue)
  end

  ## This test is successful along with work.rb validating document presence. Turned off cuz it takes a long time.
  # test "uploads a work" do 
  # 	user = users(:Isaac)
  # 	an_work = Work.create!(user_id: user.id, document: fixture_file_upload('/files/JULIA_ARDISredaction.docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'))
  # 	assert(File.exists?(an_work.reload.document.file.path))
  # end

  test "create/destroy work should increase/decrease user's works_count" do 
  	assert_difference '@sue.works_count', +1 do 
      @walden = @sue.works.create(name: "Walden")
    end
  	assert_difference '@sue.works_count', -1 do
  	  @walden.destroy
      @sue.reload # <-- don't know why reload is needed here and not above
  	end
  end

  test "create/update bookmark should increase/decrease work's bookmarked_count" do 
    @work = works(:Thesis)
    assert_difference '@work.bookmarked_count', +1 do  # <-- don't work. dunno why.
      @bookmark = @work.bookmarks.create(user_id: @sue, work_id: @work, bookmarked: true)
      @work.reload
    end
    assert_difference '@work.bookmarked_count', -1 do 
      @bookmark.update_attribute(:bookmarked, false)
    end
  end
  

end