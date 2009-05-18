module Integrity
  Project.spawner do |project|
    project.name         = Faker::Company.name
    project.uri          = Faker::Repository.public_github_uri
    project.kind         = "git"
    project.branch       = "master"
    project.build_script = "rake"
  end

  Commit.spawner do |commit|
    commit.identifier   = Faker::Repository.commit_identifier
    commit.message      = Faker::Repository.commit_message
    commit.author       = Faker::Repository.author
    commit.committed_at = Integrity::TestCase.clock - 10*60
  end
end
