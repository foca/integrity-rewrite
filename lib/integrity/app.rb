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

      def project_url(project, *path)
        url(project.permalink, *path)
      end

      def commit_url(commit, *path)
        url(commit.project.permalink, :commits, commit.identifier, *path)
      end

      def breadcrumbs
        crumbs = env["PATH_INFO"].split("/").map {|path| { :path => path, :name => path } }
        crumbs[0] = { :path => "/", :name => "projects" }
        crumbs = crumbs[0..-2].inject([]) do |crumbs_so_far, current|
          crumbs_so_far << %(<a href="#{current[:path]}">#{current[:name]}</a>)
        end << crumbs.last[:name]
        crumbs.join(" / ")
      end

      def any_management_links?
        !content_blocks[:"global.management"].empty?
      end

      def bash_color_codes(string)
        string.gsub("\e[0m", '</span>').
          gsub("\e[31m", '<span class="color31">').
          gsub("\e[32m", '<span class="color32">').
          gsub("\e[33m", '<span class="color33">').
          gsub("\e[34m", '<span class="color34">').
          gsub("\e[35m", '<span class="color35">').
          gsub("\e[36m", '<span class="color36">').
          gsub("\e[37m", '<span class="color37">')
      end

      def pretty_date(date_time)
        days_away = (Date.today - Date.new(date_time.year, date_time.month, date_time.day)).to_i
        if days_away == 0
          "today"
        elsif days_away == 1
          "yesterday"
        else
          strftime_with_ordinal(date_time, "on %b %d%o")
        end
      end

      def strftime_with_ordinal(date_time, format_string)
        ordinal = case date_time.day
          when 1, 21, 31 then "st"
          when 2, 22     then "nd"
          when 3, 23     then "rd"
          else                "th"
        end

        date_time.strftime(format_string.gsub("%o", ordinal))
      end

      def project_name(project)
        h project.name
      end

      def project_meta_status(project)
        if project.building?
          "Building."
        elsif project.last_commit.nil?
          "Never built yet."
        else
          project.human_readable_status
        end
      end

      def commit_author(commit)
        h commit.author.name
      end

      def commit_date(commit)
        h pretty_date(commit.committed_at)
      end

      def commit_message(commit)
        h commit.message
      end

      def commit_identifier(commit)
        h commit.identifier
      end

      def commit_output(commit)
        bash_color_codes h(commit.output)
      end

      alias_method :h, :escape_html
    end
  end
end
