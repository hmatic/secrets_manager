require 'thor'

module SecretsManager
  class CLI < Thor
    # secrets-manager pull
    desc "pull", "Pull secrets"
    method_option 'path',
      aliases: ['-p'],
      default: 'secrets.json',
      desc: 'Specify a json configuration file path'
    method_option 'environment',
      aliases: ['-e'],
      default: 'development',
      desc: 'Specify current environment'
    def pull
      require 'secrets_manager/cli/pull'
      SecretsManager::Cli::Pull.new(options).run
    end

    # secrets-manager pull
    desc "read NAME", "Read specific secret"
    # method_option :name, :type => :string, :required => true
    method_option 'path',
      aliases: ['-p'],
      default: 'secrets.json',
      desc: 'Specify a json configuration file path'
    method_option 'environment',
      aliases: ['-e'],
      default: 'development',
      desc: 'Specify current environment'
    def read(name)
      require 'secrets_manager/cli/read'
      SecretsManager::Cli::Read.new(options.merge(name: name)).run
    end

    # TODO: secrets-manager read
    # TODO: secrets-manager delete
    # TODO: secrets-manager update
    # TODO: secrets-manager update-value
    # TODO: secrets-manager create

    # secrets-manager version
    desc "version", "Get current gem version"
    def version
      require 'secrets_manager/version'
      puts SecretsManager::VERSION
    end
  end
end
