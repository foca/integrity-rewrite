require File.dirname(__FILE__) + "/../test_helper"

class ProjectTest < Integrity::TestCase
  test "Doesn't save without the required attributes" do
    project = Project.new
    project.valid?.should be(false)
  end

  context "Validating" do
    setup do
      @default_attributes = Project.valid_attributes
    end

    test "requires a #name" do
      project = Project.new(@default_attributes.merge(:name => nil))
      project.valid?.should be(false)
    end

    test "requires an #uri" do
      project = Project.new(@default_attributes.merge(:uri => nil))
      project.valid?.should be(false)
    end

    test "defaults #kind to git if left blank" do
      project = Project.new(:kind => nil)
      project.kind.should == "git"
    end

    test "default #build_script to 'rake' if left blank" do
      project = Project.new(:build_script => nil)
      project.build_script.should == "rake"
    end
  end

  context "Getting the associated commits" do
    setup do
      @project = Project.spawn
      10.times { Commit.spawn(:project_id => @project.id) }
    end

    test "Can get the last commit" do
      @project.last_commit.should == @project.commits.sort_by {|c| c.committed_at }.last
    end

    test "Gets the commits before the #last_commit in #previous_commits" do
      @project.previous_commits.size.should == 9
      @project.previous_commits.include?(@project.last_commit).should be(false)
    end

    test "The #previous_commits are ordered by commit time" do
      sorted_previous_commits = @project.previous_commits.sort_by {|c| c.committed_at }.reverse
      @project.previous_commits.should == sorted_previous_commits
    end
  end
end
