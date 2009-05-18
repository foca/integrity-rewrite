module Integrity
  class Project < Sequel::Model
    one_to_many :commits, :class => "Integrity::Commit"

    plugin :timestamped
    plugin :cascading, :destroy => :commits
    plugin :validation_class_methods

    validates do
      presence_of :name, :kind, :uri, :branch, :build_script
    end

    # Delegate the status of the project to the last_commit. See 
    # Integrity::Commit#status for more information.
    def status
      last_commit ? last_commit.status : "pending"
    end

    # Delegate the human readable status of the project to the 
    # last_commit. See # Integrity::Commit#human_readable_status for 
    # more information.
    def human_readable_status
      last_commit ? last_commit.human_readable_status : "Never built yet"
    end

    # Get the most recent commit to this project, or nil if no commits
    # are found.
    def last_commit
      commits_dataset.reverse_order(:committed_at).first
    end

    # Return the list of commits, ordered by date of commit (newest first),
    # except for the last one.
    def previous_commits
      commits_dataset.reverse_order(:committed_at).all.tap {|all| all.shift }
    end

    # Is this project currently being built? Returns <tt>true</tt> if
    # at least one of this project's commits is being currently built.
    def building?
      !!commits.detect {|commit| commit.building? }
    end

    # Name of the project. The <tt>permalink</tt> will be calculated 
    # from this.
    def name
      @values[:name]
    end

    # URI to the code repository. Together with <tt>kind</tt> and 
    # <tt>branch</tt> this should be enough to get the HEAD of the code 
    # in order to build.
    def uri
      @values[:uri]
    end

    # What kind of repository this is. By default <tt>git</tt> but it 
    # can be any of the supported by Bob the Builder. Check it's 
    # documentation to see the possible values.
    def kind
      @values[:kind] || "git"
    end

    # The branch in the repository to track. If none is specified,
    # then the default is <tt>master</tt>.
    def branch
      @values[:branch] || "master"
    end

    # Script to run for a given commit to "build" the project. If
    # this script returns a zero status code then the build was
    # successful, if not it was a failure. By default the script
    # is <tt>rake</tt>
    def build_script
      @values[:build_script] || "rake"
    end

    # Is this a publicly accessible project? If it is then everyone
    # can see it. If not, only logged in users can access it.
    def public
      @values[:public].nil? ? true : @values[:public]
    end
    alias_method :public?, :public

  private

    def before_create
      super

      # Normalize the permalink so it doesn't have any weird characters
      # and looks pretty
      self.permalink = (name || "").downcase.
        gsub(/'s/, "s").
        gsub(/&/, "and").
        gsub(/[^a-z0-9]+/, "-").
        gsub(/-*$/, "")
    end
  end
end
