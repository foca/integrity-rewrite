class Sequel::Model
  def self.valid_attributes(options={})
    options[:without] = Array(options[:without])
    options[:without] += [:id, :updated_at, :created_at]

    model = spawn
    model.values.tap do |values|
      model.destroy
      options[:without].each {|attr| values.delete(attr) }
    end
  end
end

module Integrity
  Project.spawner do |project|
    project.name         = Faker::Company.name
    project.uri          = Faker::Repository.public_github_uri
    project.kind         = "git"
    project.branch       = "master"
    project.build_script = "rake"

    def self.valid_attributes(options={})
      options[:without] = Array(options[:without])
      options[:without] << :permalink
      super(options)
    end
  end

  Commit.spawner do |commit|
    commit.identifier   = Faker::Repository.commit_identifier
    commit.message      = Faker::Repository.commit_message
    commit.author       = Faker::Repository.author
    commit.committed_at = Integrity::TestCase.clock - 10*60
  end
end
