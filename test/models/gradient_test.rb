require 'test_helper'

class GradientTest < ActiveSupport::TestCase

	test "should have a user_id, work_id, and grad" do
		grad = Gradient.new(user_id: nil, grad: 1, work_id: 1)
		assert_not grad.save
		grad = Gradient.new(user_id: 1, grad: nil, work_id: 1)
		assert_not grad.save
		grad = Gradient.new(user_id: 1, grad: 1, work_id: nil)
		assert_not grad.save
	end

	test "should have a unique user_id+work_id" do
		grad = Gradient.new(user_id: 1, work_id: 1, grad: 1)
		assert grad.save
		gradcopy = Gradient.new(user_id: 1, work_id: 1, grad: 1)
		assert_not gradcopy.save
	end

end
