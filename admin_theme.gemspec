# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "admin_theme/version"

Gem::Specification.new do |s|
  s.name        = "admin_theme"
  s.version     = AdminTheme::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jared Howard"]
  s.email       = ["jared@howardpants.com"]
  s.homepage    = "https://github.com/jaredhoward/admin_theme"
  s.summary     = "A gem to add styling that of ActiveAdmin."
  s.description = "AdminTheme is an Engine based gem that is used to have the same styling of ActiveAdmin without all the clutter."

  s.files         = `git ls-files`.split("\n")
  s.extra_rdoc_files = ['README.rdoc']
  s.require_paths = ['lib']

  s.licenses = ['MIT']

  s.add_dependency "rails", "~> 3.2.0"
  s.add_dependency "jquery-rails"
end
