module Integrity
  class Commit < Sequel::Model
    many_to_one :project, :class => "Integrity::Project"

    plugin :timestamped

    # Return a shortened version of the commit identifier. Useful for SCMs like
    # git that use long hashes to represent revisions. This gives a manageable
    # amount of information to display on the UI without looking clunky.
    def short_identifier
      identifier.to_s[0..6]
    end

    def status
      "success"
    end

    def human_readable_status
      "Built 123456 successfully"
    end

    def output
      "Foo"
    end

    # Return a structured representation of the author. See the Author class.
    def author
      @author ||= Author.new(@values[:author])
    end

    def building?
      false
    end

    # Structured representation of a commit author. Gives you access to the
    # name, the email, and the full "name <email>" string.
    class Author
      # Name of the author. If you initialize an author with a string like
      # <tt>"John Doe <john.doe@example.org>"</tt>. Then this will contain
      # <tt>"John Doe"</tt>.
      attr_reader :name

      # Email of the author. If you initialize an author with a string like
      # <tt>"John Doe <john.doe@example.org>"</tt>. Then this will contain
      # <tt>"john.doe@example.org"</tt>.
      attr_reader :email

      # Full representation of the author, as "name <email>". If you initialize
      # an author with a string like <tt>"John Doe <john.doe@example.org>"</tt>
      # then this will contain the exact same string.
      attr_reader :full
      alias_method :to_s, :full

      # Extract the name and email from the provided string.
      def initialize(string)
        @full = string
        @full.to_s =~ /^(.*) <(.*)>$/
        @name = $1.strip
        @email = $2.strip
      end
    end
  end
end
