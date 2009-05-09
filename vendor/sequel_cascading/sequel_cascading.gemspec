SPEC = Gem::Specification.new do |s| 
  # identify the gem
  s.name = "sequel_cascading" 
  s.version = "1.0.3" 
  s.author = "S. Brent Faulkner" 
  s.email = "brentf@unwwwired.net" 
  s.homepage = "http://github.com/sbfaulkner/sequel_cascading" 
  # platform of choice
  s.platform = Gem::Platform::RUBY
  # description of gem
  s.summary = "my take on cascading deletes via a plugin for sequel"
  s.files = %w(lib/sequel_cascading.rb MIT-LICENSE Rakefile README.markdown sequel_cascading.gemspec test/sequel_cascading_test.rb)
  s.require_path = "lib"
  s.test_file = "test/sequel_cascading_test.rb" 
  s.has_rdoc = true 
  s.extra_rdoc_files = ["README.markdown"] 
  s.add_dependency "sequel"
  # s.rubyforge_project = "sequel_cascading"
end 
