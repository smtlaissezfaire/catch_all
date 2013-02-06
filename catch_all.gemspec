# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'catch_all/version'

Gem::Specification.new do |gem|
  gem.name          = "catch_all"
  gem.version       = ActionMailer::CatchAll::VERSION
  gem.authors       = ["Scott Taylor"]
  gem.email         = ["scott@railsnewbie.com"]
  gem.description   = %q{Define a white-list only set of emails for ActionMailer}
  gem.summary       = %q{Define a white-list only set of emails for ActionMailer.  Used in staging environments.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
