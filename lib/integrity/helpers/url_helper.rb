module Integrity
  module Helpers
    # Provide helper methods to generate URLs inside integrity.
    module UrlHelper
      # Returns a string with a url inside integrity. Each string passed as an
      # argument is added to the url's path, separated by a "/". For example:
      #
      #     url("foo", "bar", "baz")
      #
      # Would return:
      #
      #     http://base.uri/foo/bar/baz
      #
      # If you are running integrity at <tt>http://base.uri</tt>. The base URI
      # is calculated from the request. See 
      # sinatra-url-for[http://github.com/emk/sinatra-url-for] for the underlying
      # library that handles getting the base URI from the http request.
      def url(*path)
        url_for path.join("/")
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
