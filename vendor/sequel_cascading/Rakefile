require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

load File.join(File.dirname(__FILE__),'sequel_cascading.gemspec')

Rake::GemPackageTask.new(SPEC) do |pkg|
end

Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end

Rake::Task[:test].comment = "Run the tests"

task :default => :test
