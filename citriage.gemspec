# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'citriage/version'

Gem::Specification.new do |spec|
  spec.name          = "citriage"
  spec.version       = Citriage::VERSION
  spec.authors       = ["Eric Putnam"]
  spec.email         = ["putnam.eric@gmail.com"]

  spec.summary       = %q{List Jenkins jobs for CI triage}
  spec.homepage      = "https://www.github.com/eputnam/citriage"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = "ci-triage"
  spec.require_paths = ["lib"]

  spec.add_dependency "rainbow", "2.1.0"
  spec.add_dependency "curb", "0.9.3"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
