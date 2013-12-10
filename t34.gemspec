$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "t34/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "t34"
  s.version     = T34::VERSION
  s.authors     = ["razum2um", "gazay"]
  s.email       = ["bokov.vlad@gmail.com", "alex.gaziev@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of T34."
  s.description = "TODO: Description of T34."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.1"
  s.add_dependency "parser"
  s.add_dependency "unparser"
  s.add_dependency "differ"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "byebug"
end
