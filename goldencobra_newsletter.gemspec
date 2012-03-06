$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "goldencobra_newsletter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "goldencobra_newsletter"
  s.version     = GoldencobraNewsletter::VERSION
  s.authors     = ["Marco Metz"]
  s.email       = ["metz@ikusei.de"]
  s.homepage    = "http://www.goldencobra.de"
  s.summary     = "Summary of GoldencobraNewsletter."
  s.description = "Description of GoldencobraNewsletter."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["CC-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"
  s.add_dependency "goldencobra"
  s.add_development_dependency "mysql2"
  s.add_development_dependency 'annotate'
  s.add_development_dependency 'guard-annotate'
  s.add_development_dependency 'pry'


end
