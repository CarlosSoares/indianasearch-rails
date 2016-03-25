$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "indianasearch/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "indianasearch"
  s.version     = IndianaSearch::VERSION
  s.authors     = ["Carlos Soares"]
  s.email       = ["carlos.soares17@gmail.com"]
  s.homepage    = "http://github.com/CarlosSoares/indiana-search"
  s.summary     = "Summary of IndianaSearch."
  s.description = "Description of IndianaSearch."
  s.license     = "MIT"
  s.require_paths = ["lib"]

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.2.4"
  s.add_dependency "rest-client"

  s.add_development_dependency "activerecord"
  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "byebug"
end
