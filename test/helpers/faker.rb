require "digest/sha1"

module Faker
  module Repository
    def self.private_github_uri
      "git@github.com:#{Internet.user_name}/#{Internet.domain_word}.git"
    end

    def self.public_github_uri
      "git://github.com/#{Internet.user_name}/#{Internet.domain_word}.git"
    end

    def self.author
      "#{Name.name} <#{Internet.email}>"
    end

    def self.commit_message
      Lorem.sentence
    end

    def self.commit_identifier
      Digest::SHA1.hexdigest(Lorem.sentence)
    end
  end
end
