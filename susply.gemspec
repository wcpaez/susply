$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "susply/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "susply"
  s.version     = Susply::VERSION
  s.authors     = ["Wenceslao Paez Chavez"]
  s.email       = ["wcpaez@gmail.com"]
  s.homepage    = "Susply"
  s.summary     = "Subscription managment for non credit card payment"
  s.description = "Robust engine for subscription managment"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "byebug"
end
