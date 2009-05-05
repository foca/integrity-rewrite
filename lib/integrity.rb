$LOAD_PATH.unshift File.dirname(__FILE__), *Dir[File.dirname(__FILE__) + "/../vendor/**/lib"].to_a

require "core_ext/object"
require "ostruct"
require "sinatra/base"
require "sequel"
require "sequel_model_hacks"
require "bob"

require "integrity/logger"
require "integrity/configurator"
require "integrity/project"

# General utility methods and configuration options for integrity.
module Integrity
  # Configure integrity via this method. Set configuration options like this:
  #
  #     Integrity.configure do |config|
  #       config.log_file     = "log/integrity.log"
  #       config.base_uri     = "http://builder.integrityapp.com"
  #       config.database_uri = "sqlite3://integrity.db"
  #     end
  #
  # The configuration options used throughout the app are:
  #
  # * <tt>log_file</tt>
  #   File to store integrity's log. Defaults to <tt>STDOUT</tt>.
  # * <tt>logger</tt>
  #   Logger object used to log throughout the application. It defaults to a Logger
  #   instance that logs to <tt>config.log_file</tt> and cycles the log every 1 MiB, 
  #   keeping 7 old log files.
  # * <tt>database_uri</tt>
  #   URI to your database, as required by the sequel[http://sequel.rubyforge.org] API.
  # * <tt>database</tt>
  #   Database connection used in Integrity. It defaults to whatever driver is appropriate
  #   according to <tt>Integrity.config.database_uri</tt>
  # * <tt>base_uri</tt>
  #   URI where your integrity install lives (for example, <tt>http://builder.integrityapp.com</tt>)
  #
  # You can access the configuration with <tt>Integrity.config</tt>
  def self.configure(&block) # :yields: config
    @config ||= Configurator.new do |defaults|
      defaults.log_file     = STDOUT
      defaults.base_uri     = "http://localhost:8910"
      defaults.database_uri = "sqlite://integrity.db"
      defaults.build_path   = Bob.directory
    end

    @config.tap {|c| block.call(c) if block }
  end

  class << self
    alias_method :config, :configure
  end

  # Integrity's logger, defaults to logging at whatever stream is specified in 
  # <tt>config.log_file</tt>. May be modified by setting <tt>config.logger</tt>
  def self.logger
    config.logger ||= Logger.new(config.log_file)
  end

  # Database connection, using whatever adapter you specified in 
  # <tt>config.database_uri</tt>.
  def self.database
    config.database ||= Sequel.connect(config.database_uri, :loggers => [self.logger])
  end
end
