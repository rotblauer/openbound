require 'test_helper'

class WorkTest < ActiveSupport::TestCase

  def setup
    @work = users(:User_2).works.build(
      file_content_md: "Hello",
      school_id: users(:User_2).school_primary.id
    )
  end

  def on_create_callback_skips
    # Callback skippers called from controller.
    Work.skip_callback(:update, :after, :update_diffs_if_any)
    Work.skip_callback(:update, :after, :save_revision)
    Work.skip_callback(:update, :after, :update_if_file_content_md_changed)
    Work.skip_callback(:update, :after, :update_if_file_content_text_changed)
  end

  test "fixture should be valid" do
    assert works(:Work_1).valid?
  end

  test "setup should be valid" do
    assert @work.valid?
  end

  test "should have to have file content" do
    @work.file_content_md = nil
    assert_not @work.valid?
  end

  test "should belong to a user" do
    assert @work.user_id == users(:User_2).id
  end

  test "work belongs to a project on save" do
    # on_create_callback_skips
    assert @work.save
    @work.reload
    assert @work.project_id.present?
  end

  test "work gets a revision when file content md changes" do
    # Should get revision#1 on after create.
    assert @work.save
    @work.reload
    assert_equal(1, @work.revisions.count)
    json_data = JSON.parse @work.revisions.first.data
    assert_equal(@work.file_content_md, json_data["file_content_md"]) # Revision matches.
    assert_equal(@work.file_content_md, @work.project.file_content_md) # Project matches.

    # And revision#2 after an edit.
    @work.file_content_md = "Different"
    @work.save
    @work.reload
    assert_equal(2, @work.revisions.count)
    json_data = JSON.parse @work.revisions.second.data
    assert_equal(@work.file_content_md, json_data["file_content_md"]) # Revision matches.
    assert_equal(@work.file_content_md, @work.project.file_content_md) # Project matches.
  end

  test "work gets all content types" do
    assert @work.save
    @work.reload

    # Content types are filled by Work#init_textuals
    assert_not_nil(@work.file_content_md)
    assert_not_nil(@work.file_content_text)
    assert_not_nil(@work.file_content_html)

    # Project init.
    assert @work.file_content_text.include? @work.file_content_md # Hello\n
    assert @work.file_content_html.include? @work.file_content_md # <p>Hello</p>\n
  end



end
