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

    def building?
      false
    end
  end
end
