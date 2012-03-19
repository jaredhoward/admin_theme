# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "admin_theme/version"

Gem::Specification.new do |s|
  s.name        = "admin_theme"
  s.version     = AdminTheme::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jared Howard"]
  s.email       = ["jared@howardpants.com"]
  s.homepage    = "https://github.com/jaredhoward/admin-theme"
  s.summary     = "A gem to add styling that of ActiveAdmin and maybe other in the future."
  s.description = "A gem to add styling that of ActiveAdmin and maybe other in the future."

  s.files         = `git ls-files`.split("\n")
  s.extra_rdoc_files = ['README.rdoc']
  s.require_paths = ['lib']

  s.licenses = ['MIT']

  s.add_dependency "rails", "~> 3.2.0"
end
