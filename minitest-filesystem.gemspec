# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minitest/filesystem/version'

Gem::Specification.new do |gem|
  gem.name          = "minitest-filesystem"
  gem.version       = Minitest::Filesystem::VERSION
  gem.authors       = ["Stefano Zanella"]
  gem.email         = ["zanella.stefano@gmail.com"]
  gem.description   = %q{Minitest exstension to check filesystem contents}
  gem.summary       = %q{Adds assertions and expectations to check the content
                         of a filesystem tree with minitest}
  gem.homepage      = "https://github.com/stefanozanella/minitest-filesystem"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|gem|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.3"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "coveralls"
end
