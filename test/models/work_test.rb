require 'test_helper'

class WorkTest < ActiveSupport::TestCase

  def setup

    @work = users(:Admin).works.build(
      file_content_md: "Hello",
      school_id: users(:Admin).school_primary.id
    )
  end

  test "fixture should be valid" do
    assert works(:Work1).valid?
  end

  test "setup should be valid" do
    assert @work.valid?
  end

  test "should have a project" do
    assert @work.project_id.present?
  end

  # test "fixtures should be valid (while muting validate_presence_of :document callback)" do
  # 	work = works(:alladin_work)
  # 	assert work.valid?
  #   work = works(:moses_work)
  #   assert work.valid?
  #   work = works(:hiro_work)
  #   assert work.valid?
  #   work = works(:fengshui_work)
  #   assert work.valid?
  #   work = works(:zorba_work)
  #   assert work.valid?
  #   work = works(:rasputin_work)
  #   assert work.valid?
  # end

  # test "maximum upload limit per user is 100mb" do
  #   # bring ya right up to the edge
  #   20.times do |n|
  #     Work.create!(works(:Work1).attributes)
  #   end
  #   # pushes ya off
  #   camel_straw = Work.new(works(:Work1).attributes)
  #   assert_not camel_straw.save
  # end

end
