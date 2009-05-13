def __ROOT__
  File.expand_path(File.dirname(__FILE__) + "/../")
end

require "test/unit"
require "contest"
require "matchy"
require "rr"
require "sequel/extensions/migration"

begin
  require "redgreen"
rescue LoadError
end

if ENV["DEBUG"]
  require "ruby-debug"
else
  def debugger
    puts "Run your tests with DEBUG=1 to use the debugger"
  end
end

require "#{__ROOT__}/lib/integrity"

class Integrity::TestCase < Test::Unit::TestCase
  include RR::Adapters::TestUnit
  include Integrity

  def reset_config
    Integrity.configure do |config|
      config.database_uri = "sqlite::memory:"
      config.log_file     = "/dev/null"
      config.build_path   = "#{__ROOT__}/tmp"
    end
  end

  def reset_database
    Sequel::Migrator.apply(Integrity.database, "#{__ROOT__}/lib/integrity/migrations")
    %w(project commit build).each do |model|
      load "#{__ROOT__}/lib/integrity/#{model}.rb"
    end
  end

  setup do
    reset_config
    reset_database
  end
end
