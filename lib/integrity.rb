$LOAD_PATH.unshift File.dirname(__FILE__), *Dir[File.dirname(__FILE__) + "/../vendor/**/lib"].to_a

require "core_ext/object"
require "ostruct"

require "sinatra/base"
require "sequel"
require "sequel_model_hacks"
require "bob"

require "integrity/project"

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
    @config ||= default_configuration
    @config.tap { block.call(@config) if block }
  end

  class << self
    alias_method :config, :configure
  end

  # Integrity's logger, defaults to logging at whatever stream is specified in 
  # <tt>config.log_file</tt>. May be modified by setting <tt>config.logger</tt>
  def self.logger
    config.logger ||= default_logger
  end

  # Database connection, using whatever adapter you specified in 
  # <tt>config.database_uri</tt>.
  def self.database
    config.database ||= Sequel.connect(config.database_uri, :loggers => [self.logger])
  end

  def self.default_configuration
    OpenStruct.new(:log_file     => STDOUT,
                   :base_uri     => "http://localhost:8910",
                   :database_uri => "sqlite://integrity.db")
  end
  private_class_method :default_configuration

  def self.default_logger
    Logger.new(config.log_file, 7, 1024**2).tap do |logger|
      logger.level = Logger::INFO
      logger.formatter = LogFormatter.new
    end
  end
  private_class_method :default_logger

  class LogFormatter < Logger::Formatter #:nodoc:
    def call(severity, time, progname, msg)
      time.strftime("[%H:%M:%S] ") + msg2str(msg) + "\n"
    end
  end
end
