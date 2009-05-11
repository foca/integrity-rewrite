module Integrity
  class Commit < Sequel::Model
    many_to_one :project, :class => "Integrity::Project"

    plugin :timestamped

    def status
      "success"
    end

    def human_readable_status
      "Built 123456 successfully"
    end

    def output
      "Foo"
    end

    def author
      @author ||= Author.new(@values[:author])
    end

    def building?
      false
    end

    # Structured representation of a commit author. Gives you access to the
    # name, the email, and the full "name <email>" string.
    class Author
      attr_reader :name, :email

      def initialize(string)
        string.to_s =~ /^(.*) <(.*)>$/
        @name = $1.strip
        @email = $2.strip
      end

      def full
        @full ||= "#{name} <#{email}>"
      end
      alias_method :to_s, :full
    end
  end
end
