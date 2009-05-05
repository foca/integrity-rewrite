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

    # The build path is where each build will be stored. Since this is
    # handled by Bob the Builder, we just forward this setting there.
    def build_path # :nodoc:
      Bob.directory
    end

    # The build path is where each build will be stored. Since this is
    # handled by Bob the Builder, we just forward this setting there.
    def build_path=(path) # :nodoc:
      Bob.directory = path
      super(path)
    end
  end
end
