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
end
