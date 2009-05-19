require File.dirname(__FILE__) + "/../test_helper.rb"

class TestIntegrity < Integrity::TestCase
  test "both #config and #configure return an Integrity::Configurator" do
    Integrity.config.is_a?(Integrity::Configurator).should be(true)
    Integrity.configure.is_a?(Integrity::Configurator).should be(true)

    Integrity.config.should == Integrity.configure
  end

  context "The default options" do
    setup do
      @testing_config = Integrity.config
      Integrity.instance_variable_set(:@config, nil)
    end

    teardown do
      Integrity.instance_variable_set(:@config, @testing_config)
    end

    test "logs to STDOUT" do
      Integrity.config.log_file.should == STDOUT
    end

    test "uses sqlite://integrity.db as the database" do
      Integrity.config.database_uri.should == "sqlite://integrity.db"
    end

    test "sets Bob's build directory as the build_path" do
      Integrity.config.build_path.should == Bob.directory
    end
  end
end
