require 'test_helper'

class WorkTest < ActiveSupport::TestCase

  def setup
    @work = works(:Work1)
  end

  # test "thingy" do
  #   assert @work.valid?
  # end

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
  #     Work.create!(name: "n+#{n}", file_size: 5.megabytes, user_id: users(:Isaac).id)
  #   end
  #   # pushes ya off
  #   camel_straw = Work.new(name: "n1--", file_size: 5.megabytes, user_id: users(:Isaac).id)
  #   assert_not camel_straw.save
  # end


end
