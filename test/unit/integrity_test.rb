require File.dirname(__FILE__) + "/../test_helper.rb"

class TestIntegrity < Test::Unit::TestCase
  test "both #config and #configure return an Integrity::Configurator" do
    Integrity.config.is_a?(Integrity::Configurator).should be(true)
    Integrity.configure.is_a?(Integrity::Configurator).should be(true)

    Integrity.config.should == Integrity.configure
  end
end
