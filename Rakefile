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
task :vendor => %w(vendor:prepare vendor:bob)

namespace :vendor do
  task :prepare do
    `mkdir -p vendor`
  end

  desc "Vendor Bob the Builder"
  task :bob => "bob:clobber" do
    Dir.chdir("vendor") do
      `gem unpack bob-the-builder && mv bob-the-builder* bob-the-builder`
    end
  end

  task "bob:clobber" do
    FileUtils.rm_r("vendor/bob-the-builder") if File.directory?("vendor/bob-the-builder")
  end
end

namespace :db do
  task :migrate => :environment do
    require "sequel/extensions/migration"
    Sequel::Migrator.apply(Integrity.database, File.dirname(__FILE__) + "/lib/integrity/migrations")
  end
end

task :environment do
  def run(x); end
  def use(x); end
  load "config.ru"
end
