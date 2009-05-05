__ROOT__ = File.expand_path(File.dirname(__FILE__) + "/../")

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

module Integrity::TestHelpers
  def reset_database
    File.rm("#{__ROOT__}/test.db") if File.file?("#{__ROOT__}/test.db")
    Sequel::Migrator.apply(Integrity.database, "#{__ROOT__}/lib/integrity/migrations")
  end

  def reset_config
    Integrity.configure do |config|
      config.database_uri = "sqlite://test.db"
      config.log_file     = "/dev/null"
      config.build_path   = "#{__ROOT__}/tmp"
    end
  end
end

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
  include Integrity
  include TestHelpers

  setup do
    reset_config
    reset_database
  end
end
