$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "admin_theme/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "admin_theme"
  s.version     = AdminTheme::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jared Howard"]
  s.email       = ["jared@howardpants.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AdminTheme."
  s.description = "TODO: Description of AdminTheme."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.0"
end
