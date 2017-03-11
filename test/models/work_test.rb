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

end
