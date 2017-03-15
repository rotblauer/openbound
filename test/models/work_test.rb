require 'test_helper'

class WorkTest < ActiveSupport::TestCase

  def setup
    @work = users(:User_2).works.build(
      file_content_md: "Hello",
      school_id: users(:User_2).school_primary.id
    )

    @work_different = users(:User_2).works.build(
      file_content_md: "Hello again",
      school_id: users(:User_2).school_primary.id
    )
    @new_work = users(:User_2).works.build(
      project_id: works(:Work_1).project_id,
      school_id: users(:User_2).school_primary.id,
      document: fixture_file_upload('files/AugustineasanAuthorHisEarlyLifeinConfessions.docx')
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

  test "should create a diff when uploading two works to same project" do
    assert @work.save
    @work.reload

    @work_different.project_id = @work.project_id
    assert @work_different.save
    @work_different.reload

    assert_equal @work.project_id, @work_different.project_id
    @work_different.project.reload

    project = @work_different.project

    assert_equal @work.project.id, project.id

    assert_equal @work_different.project.file_content_md, @work_different.file_content_md
    assert_equal 1, project.diffs.count

    diff = project.diffs.first

    assert_equal @work.id, diff.work1
    assert_equal @work_different.id, diff.work2
    assert_equal project.id, diff.project_id
  end

  test "diff should update when md changes on same work" do
    assert @work.save
    @work.reload

    @work_different.project_id = @work.project_id
    assert @work_different.save
    @work_different.reload

    project = @work_different.project
    diff = project.diffs.first

    @work_different.file_content_md = @work_different.file_content_md + " blah"
    @work_different.save

    diff.reload
    assert diff.right_text.include? "blah"
    assert_not diff.left_text.include? "blah"
  end

  test "should be able to upload a new work from file" do
    assert @new_work.save
    @new_work.reload

    # Ensure same project as fixture
    assert_equal @new_work.project.id, works(:Work_1).project.id

    # Ensure got parsed file_contents
    assert @new_work.file_content_md.present?
    assert @new_work.file_content_html.present?
    assert @new_work.file_content_text.present?

    assert works(:Work_1).file_content_md.include? "Freshman"

    assert @new_work.file_content_md.include? "Sophomore"
    assert_not @new_work.file_content_md.include? "Freshman"

    # Diffs
    assert_equal 1, @new_work.project.diffs.count

    diff = @new_work.project.diffs.first
    puts "\n\ndiff => #{diff.inspect}\n\n"

    assert_equal diff.work1, works(:Work_1).id
    assert_equal diff.work2, @new_work.id

    assert_not diff.left === diff.right

    # pdfs and plain texts get left_texts (and right, duh), while other apparently just get left
    assert diff.left or diff.left_text
    assert diff.right or diff.right_text

    assert_not diff.left.include? "Sophomore"
    assert diff.right.include? "Sophomore"

    assert_equal 2, @new_work.project.works.count
    # assert_equal 2, @new_work.project.works_count
  end

end
