# frozen_string_literal: true

require_relative "lib/mainorequests/version"

Gem::Specification.new do |spec|
  spec.name = "mainorequests"
  spec.version = Mainorequests::VERSION
  spec.authors = ["Thiago Portella", "Mainô Sistemas"]
  spec.email = %w[thiagoportella@maino.com.br desenvolvedores@maino.com.br]

  spec.summary = "Faraday-based library for HTTP communication."
  spec.description = "Request control using ratelimit and user configuration for each implementation."
  spec.homepage = "https://github.com/mainosistemas/mainorequests."
  spec.required_ruby_version = ">= 2.6.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
