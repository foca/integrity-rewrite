require "rake/testtask"

begin
  require "hanna/rdoctask"
rescue LoadError
  require "rake/rdoctask"
end

Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.title = "API Documentation for Integrity"
  rd.rdoc_files.include("README", "LICENSE", "lib/**/*.rb")
  rd.rdoc_dir = "doc"
end

begin
  require "metric_fu"
rescue LoadError
end

begin
  require "mg"
  MG.new("integrity.gemspec")

  task :build => :vendor
rescue LoadError
end

desc "Default: run tests"
task :default => :test

desc "Run web application tests"
Rake::TestTask.new(:test) do |t|
  t.test_files = FileList["test/**/*_test.rb"]
end

# ensure we have all dependencies bundled when we run tests
task :test => :vendor

desc "Bundle internal dependencies (for ease of use)"
task :vendor => %w(vendor:prepare vendor:bob vendor:beacon)

namespace :vendor do
  task :prepare do
    `mkdir -p vendor`
  end

  def vendor_lib(lib_name, gem_name=lib_name)
    desc "Vendor #{gem_name}"
    task lib_name => "#{lib_name}:clobber" do
      Dir.chdir("vendor") do
        `gem unpack #{gem_name} && mv #{gem_name}* #{gem_name}`
      end
    end

    task "#{lib_name}:clobber" do
      FileUtils.rm_r("vendor/#{gem_name}") if File.directory?("vendor/#{gem_name}")
    end
  end

  vendor_lib :bob, "bob-the-builder"
  vendor_lib :beacon
end

namespace :db do
  desc "Migrate the database to the latest version"
  task :migrate => :environment do
    require "sequel/extensions/migration"
    Sequel::Migrator.apply(Integrity.database, File.dirname(__FILE__) + "/lib/integrity/migrations")
  end
end

desc "Load the config file (probably only to be used as a dependency on other tasks...)"
task :environment do
  ENV["CONFIG"] ||= File.dirname(__FILE__) + "/config.rb"
  ENV["CONFIG"] = File.expand_path(ENV["CONFIG"])

  if File.file?(ENV["CONFIG"])
    require ENV["CONFIG"]
  else
    puts "No config file found at #{ENV["CONFIG"]}"
  end
end
