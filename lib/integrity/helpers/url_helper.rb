module Integrity
  module Helpers
    # Provide helper methods to generate URLs inside integrity.
    module UrlHelper
      # Returns the full URL to integrity's project list, as defined in
      # <tt>config.base_uri</tt>. Check the documentation of <tt>Integrity#config</tt>. 
      # This is returned as an <tt>Addressable::URI</tt>.
      def root_url
        @root_url ||= Addressable::URI.parse(Integrity.config.base_uri)
      end

      # Returns a string with a url inside integrity. Each string passed as an
      # argument is added to the url's path, separated by a "/". For example:
      #
      #     url("foo", "bar", "baz")
      #
      # Would return:
      #
      #     http://localhost:8910/foo/bar/baz
      #
      # If you have <tt>http://localhost:8910</tt> defined as your base uri in the 
      # config (the default).
      def url(*path)
        root_url.dup.tap {|url| url.path = root_url.path + path.join("/") }.to_s
      end

      # For simplicity, pass a Project instance and it will write the correct URL.
      # You can pass more arguments and it will work the same way as <tt>url</tt>
      # does.
      def project_url(project, *path)
        url(project.permalink, *path)
      end

      # For simplicity, pass a Commit instance and it will wirte the correct URL.
      # You can pass more arguments and it will work the same way as <tt>url</tt>
      # does.
      def commit_url(commit, *path)
        url(commit.project.permalink, :commits, commit.identifier, *path)
      end
    end
  end
end
