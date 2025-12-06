# -*- encoding: utf-8 -*-
# stub: device 0.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "device".freeze
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org/" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Konstantin Papkovskiy".freeze]
  s.bindir = "exe".freeze
  s.date = "2016-10-07"
  s.email = ["konstantin@papkovskiy.com".freeze]
  s.rubygems_version = "3.4.19".freeze
  s.summary = "Device detection".freeze

  s.installed_by_version = "3.4.19" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.12"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
end
