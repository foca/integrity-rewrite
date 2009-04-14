module Integrity
  # Web UI to integrity.
  class App < Sinatra::Base
    set :root,     File.expand_path(File.dirname(__FILE__) + "/../..")
    set :app_file, __FILE__
    enable :sessions

    get "/integrity.css" do
      "CSS Stylesheet"
    end

    get "/?" do
      "Project list"
    end

    get "/new" do
      "New project"
    end

    post "/?" do
      "Create new project"
    end

    get "/:project/?" do |project|
      "Show #{project}"
    end

    get "/:project.atom" do |project|
      "Show feed for #{project}"
    end

    get "/:project/edit/?" do |project|
      "Edit #{project}"
    end

    put "/:project/?" do |project|
      "Update #{project}"
    end

    delete "/:project/?" do |project|
      "Destroy #{project}"
    end

    get "/:project/push" do |project|
      "Show instructions for pushing to #{project}"
    end

    post "/:project/push" do |project|
      "Queue new commits to be built"
    end

    post "/:project/builds" do |project|
      "Manual build for #{project}"
    end

    get "/:project/commits/:commit/?" do |project, commit|
      "Show info for #{commit} on #{project}"
    end

    post "/:project/commits/:commit/builds/?" do |project, commit|
      "Rebuild the commit #{commit} of #{project}"
    end
  end
end
