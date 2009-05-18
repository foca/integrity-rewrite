module Integrity
  module Helpers
    # Provides helper methods to access attributes of models.
    module AccessorHelper
      # Returns the name of a project to display on the website.
      def project_name(project)
        h project.name
      end

      # Returns the current status of a project. Delegating to
      # <tt>Project#human_readable_status</tt>. See that method
      # for more information.
      def project_status(project)
        h project.human_readable_status
      end

      # Returns a commit's author name to display on the website.
      def commit_author(commit)
        h commit.author.name
      end

      # Returns the date of a commit to display on the website.
      def commit_date(commit)
        h pretty_date(commit.committed_at)
      end

      # Returns the commit message of the commit, to display on 
      # the website
      def commit_message(commit)
        h commit.message
      end

      # Returns the identifier (appropriate to whatever kind of
      # repository this commit is—SHA hashes for git repos, 
      # numerical revisions for svn repos, etc) to display on the
      # website.
      def commit_identifier(commit)
        h commit.identifier
      end

      # Returns the shortened version of the commit identifier.
      # Useful for git-like SCMs where the commit identifier is
      # a long hash.
      def short_commit_identifier(commit)
        h commit.short_identifier
      end

      # Returns the output of a build, stripped of all bash color
      # codes and replaced by appropriate HTML tags that allow
      # styling.
      def commit_output(commit)
        bash_color_codes h(commit.output)
      end
    end
  end
end
