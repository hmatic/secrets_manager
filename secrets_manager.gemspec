$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "secrets_manager/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "secrets_manager"
  s.version     = SecretsManager::VERSION
  s.authors     = ["hmatic"]
  s.email       = ["web.hmatic@gmail.com"]
  s.homepage    = "http://hrvojematic.com"
  s.summary     = "Inject AWS Secret Manager secrets into rails process"
  s.description = "Bla bla bla"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "aws-sdk-secretsmanager", "~> 1.20.0"
  s.add_dependency "thor"

  s.add_development_dependency 'pry'

  s.executables << "secrets_manager"

end
