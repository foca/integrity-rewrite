require File.dirname(__FILE__) + "/../test_helper"

class ProjectTest < Integrity::TestCase
  test "Doesn't save without the required attributes" do
    project = Project.new
    project.valid?.should be(false)
  end
end
