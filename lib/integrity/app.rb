module Integrity
  # Web UI to integrity.
  class App < Sinatra::Default
    set :root,     File.expand_path(File.dirname(__FILE__) + "/../..")
    set :app_file, __FILE__
    enable :sessions

    helpers Sinatra::ContentFor, Sinatra::UrlForHelper, Integrity::Helpers

    before do
      Integrity.database # force connect
    end

    get "/user_styles.css" do
      content_type "text/css"
      yield_content "global.stylesheets"
    end

    get "/user_scripts.js" do
      content_type "text/javascript"
      yield_content "global.javascripts"
    end

    get "/?" do
      @projects = Project.all
      render_page :list, "projects"
    end

    get "/new" do
      @project = Project.new
      render_page :new, "new project"
    end

    post "/?" do
      @project = Project.new(params[:project_data])

      if @project.save
        redirect project_url(@project)
      else
        render_page :new, "new project"
      end
    end

    get "/:project/?" do |project|
      @project = Project.first(:permalink => project)
      @commit = @project.last_commit
      render_page :show, project
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

    helpers do
      def render_page(view, title)
        @title = title
        erb view
      end

      def any_management_links?
        !content_blocks[:"global.management"].empty?
      end

      alias_method :h, :escape_html
    end
  end
end
