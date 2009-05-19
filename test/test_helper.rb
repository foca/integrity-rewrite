def __ROOT__
  File.expand_path(File.dirname(__FILE__) + "/../")
end

require "test/unit"
require "contest"
require "matchy"
require "rr"
require "spawner"
require "faker"
require "sequel/extensions/migration"
require "#{__ROOT__}/test/helpers/faker"

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

Sequel::Model.extend Spawner

class Integrity::TestCase < Test::Unit::TestCase
  include RR::Adapters::TestUnit
  include Integrity

  # Use as a stub for Time.now when needed, so it doesn't change
  # through the tests
  def self.now
    @now ||= Time.now
  end

  # Each time you call it, it returns a Time object <tt>seconds</tt> later
  # than the last. The first time it returns TestCase.now
  def self.clock(seconds=1)
    @ticks ||= -seconds
    @ticks += seconds
    now + @ticks
  end

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
    load "#{__ROOT__}/test/helpers/factories.rb"
  end

  setup do
    reset_config
    reset_database
  end
end
