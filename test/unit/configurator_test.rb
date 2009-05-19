require File.dirname(__FILE__) + "/../test_helper"

class TestConfigurator < Integrity::TestCase
  setup do
    @config = Configurator.new do |config|
      config.log_file = "/integrity.log"
    end
  end

  test "Sets the default configuration on the constructor" do
    @config.log_file.should == "/integrity.log"
  end

  test "Will overwrite default settings" do
    @config.log_file = "/var/log/integrity.log"
    @config.log_file.should == "/var/log/integrity.log"
  end

  test "Changing Bob.directory changes the build_path" do
    Bob.directory = "/foo/bar"
    @config.build_path.should == "/foo/bar"
  end

  test "Changing the build_path will change Bob.directory" do
    @config.build_path = "/foo/bar"
    Bob.directory.should == "/foo/bar"
  end

  test "The database connects automatically to whatever is set in database_uri" do
    @config.database_uri = "sqlite::memory:"
    @config.database.is_a?(Sequel::Database).should be(true)
  end

  test "The logger is instantiated automatically if unavailable" do
    @config.log_file = "/dev/null"
    @config.logger.is_a?(Integrity::Logger).should be(true)
  end

  context "Available options" do
    def self.it_understands(*options)
      options.each do |option|
        test "understands #{option}" do
          @config.respond_to?(option).should be(true)
          @config.respond_to?("#{option}=").should be(true)
        end
      end
    end

    it_understands :log_file, :logger, :database_uri, :database,
                   :build_path, :base_uri
  end
end
