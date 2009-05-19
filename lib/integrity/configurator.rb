module Integrity
  # Set configuration options for integrity.
  class Configurator
    # File to store integrity's log. See <tt>Configurator#logger</tt>.
    attr_accessor :log_file

    # URI to your database, as defined by Sequel[http://sequel.rubyforge.org]'s
    # API. See <tt>Configurator#database</tt>.
    attr_accessor :database_uri

    # Base URI to integrity. This should be used to generate URIs to integrity
    # from outside the context of the web application (which can get the base
    # URI from it's environment), like from Notifiers.
    #
    # Unless the user changes it, the web application will set it from its
    # environment after the first request to it it's made.
    attr_accessor :base_uri

    # Set the default config. Use like this:
    #
    #     config = Configurator.new do |defaults|
    #       defaults.log_file = "/tmp/integrity.log"
    #     end
    #
    #     config.foo #=> "/tmp/integrity.log"
    def initialize # :yields: default_config
      yield self if block_given?
    end

    # The build path is where each build will be stored. Since this is
    # handled by Bob the Builder, we just forward this setting there.
    def build_path
      Bob.directory
    end

    # The build path is where each build will be stored. Since this is
    # handled by Bob the Builder, we just forward this setting there.
    def build_path=(path)
      Bob.directory = path
    end

    # Integrity's logger, defaults to logging at whatever stream is specified in
    # <tt>log_file</tt>.
    def logger
      @logger ||= Integrity::Logger.new(log_file)
    end

    # Change the logger object to handle integrity's logging.
    def logger=(logger)
      @logger = logger
    end

    # Database connection. If none is present it will automatically connect to
    # whatever adapter is specified in <tt>Configurator#database_uri</tt>.
    def database
      @database ||= Sequel.connect(database_uri, :loggers => logger)
    end

    # Set the database connection to use by integrity.
    def database=(connection)
      @database = connection
    end
  end
end
