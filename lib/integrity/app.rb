module Integrity
  # Web UI to integrity.
  class App < Sinatra::Default
    set :root,     File.expand_path(File.dirname(__FILE__) + "/../..")
    set :app_file, __FILE__
    enable :sessions

    helpers Sinatra::ContentFor

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

    helpers do
      def render_page(view, title)
        @title = Array(title)
        erb view
      end

      def cycle(*values)
        @cycles ||= {}
        @cycles[values] ||= -1 # first value returned is 0
        next_value = @cycles[values] = (@cycles[values] + 1) % values.size
        values[next_value]
      end

      def root_url
        @root_url ||= Addressable::URI.parse(Integrity.config.base_uri)
      end

      def url(*path)
        root_url.dup.tap {|url| url.path = root_url.path + path.join("/") }.to_s
      end

      def project_url(project)
        url(project.permalink)
      end

      def commit_url(commit)
        url(commit.project.permalink, :commits, commit.identifier)
      end

      def breadcrumbs
        crumbs = env["PATH_INFO"].split("/").map {|path| { :path => path, :name => path } }
        crumbs[0] = { :path => "/", :name => "projects" }
        crumbs = crumbs[0..-2].inject([]) do |crumbs_so_far, current|
          crumbs_so_far << %(<a href="#{current[:path]}">#{current[:name]}</a>)
        end << crumbs.last[:name]
        crumbs.join(" / ")
      end

      alias_method :h, :escape_html
    end
  end
end
