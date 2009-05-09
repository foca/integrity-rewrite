module Integrity
  class Project < Sequel::Model
    def status
      last_commit && last_commit.status
    end

    def human_readable_status
      last_commit && last_commit.human_readable_status
    end

    def last_commit
      nil
    end

    # Is this project currently being built? Returns <tt>true</tt> or 
    # <tt>false</tt>.
    def building?
      false
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
  end
end
