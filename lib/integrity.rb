$LOAD_PATH.unshift File.dirname(__FILE__), *Dir[File.dirname(__FILE__) + "/../vendor/**/lib"].to_a

require "core_ext/object"
require "ostruct"
require "sinatra/base"
require "sinatra/content_for"
require "sinatra/url_for"
require "sequel"
require "sequel_on_connect"
require "sequel/extensions/migration"
require "bob"

require "integrity/logger"
require "integrity/configurator"
require "integrity/helpers"

Sequel.on_connect do
  begin
    require "integrity/project"
    require "integrity/commit"
    require "integrity/build"
  rescue Sequel::DatabaseError
    # when migrating we don't have the tables available yet, so requiring
    # the models raises an error
  end
end

Sequel::Model.raise_on_save_failure = false

# General utility methods and configuration options for integrity.
module Integrity
  # Configure integrity via this method. Set configuration options like this:
  #
  #     Integrity.configure do |config|
  #       config.log_file     = "log/integrity.log"
  #       config.database_uri = "sqlite3://integrity.db"
  #     end
  #
  # You can access the configuration with <tt>Integrity.config</tt>
  #
  # See Integrity::Configurator to see all the configuration options available.
  def self.configure(&block) # :yields: config
    @config ||= Configurator.new do |defaults|
      defaults.log_file     = STDOUT
      defaults.database_uri = "sqlite://integrity.db"
      defaults.build_path   = Bob.directory
    end

    @config.tap {|c| block.call(c) if block }
  end

  class << self
    alias_method :config, :configure
  end

  # Convenience method to get the logger. See <tt>Configurator#logger</tt>.
  def self.logger
    config.logger
  end

  # Convenience method to get the database connection. See 
  # <tt>Configurator#database</tt>.
  def self.database
    config.database
  end
end
