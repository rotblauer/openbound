
require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  def setup
    @project_fixture = projects(:Project_1)
  end

  test "fixture should be valid" do
    assert @project_fixture.valid?
  end
end
