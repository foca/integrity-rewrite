require File.dirname(__FILE__) + "/../test_helper"

class TestConfigurator < Test::Unit::TestCase
  setup do
    @config = Configurator.new do |config|
      config.foo = 1
    end
  end

  test "Sets the default configuration on the constructor" do
    @config.foo.should == 1
  end

  test "Will overwrite default settings" do
    @config.foo = 2
    @config.foo.should == 2
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
