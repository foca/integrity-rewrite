module Integrity
  # Wrapper around OpenStruct to set configuration options.
  class Configurator < OpenStruct
    # Set the default config. Use like this:
    #
    #     config = Configurator.new do |defaults|
    #       defaults.foo = 1
    #     end
    #
    #     config.foo #=> 1
    def initialize # :yields: default_config
      super
      yield self if block_given?
    end

    def build_path=(path) #:nodoc: maybe this method should be documented to state it's side effects? dunno
      super(Bob.directory = path)
    end
  end
end
