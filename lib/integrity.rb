$LOAD_PATH.unshift *Dir[File.dirname(__FILE__) + "/../vendor/**/lib"].to_a

require "ostruct"

require "core_ext/object"

require "bob"
require "sinatra/base"

module Integrity
  # Configure integrity via this method. Set configuration options like this:
  #
  #     Integrity.configure do |config|
  #       config.log_file = "log/integrity.log"
  #       config.base_uri = "http://builder.integrityapp.com"
  #     end
  #
  # The configuration options used throughout the app are:
  #
  # * <tt>log_file</tt>
  #   File to store integrity's log. Defaults to <tt>STDOUT</tt>.
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
  # <tt>config.log_file</tt>. May be modified by setting <tt>Integrity.config.logger</tt>
  def self.logger
    config.logger ||= default_logger
  end

  def self.default_configuration
    OpenStruct.new(:log_file => STDOUT,
                   :base_uri => "http://localhost:8910")
  end
  private_class_method :default_configuration

  def self.default_logger
    Logger.new(config[:log_file], 7, 1024**2).tap do |logger|
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
