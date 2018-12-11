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

    # TODO: secrets-manager read
    # TODO: secrets-manager delete
    # TODO: secrets-manager update
    # TODO: secrets-manager update-value
    # TODO: secrets-manager create
  end
end
