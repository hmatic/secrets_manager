require 'thor'

module SecretsManager
  class CLI < Thor
    # secrets-manager pull
    desc "pull", "Pull secrets"
    method_option 'environment',
      aliases: ['-e'],
      default: 'development',
      desc: 'Specify current environment'
    method_option 'profile',
      default: 'default',
      desc: 'Specify AWS profile'
    method_option 'path',
      aliases: ['-p'],
      default: 'secrets.json',
      desc: 'Specify a json configuration file path'

    def pull
      require 'secrets_manager/cli/pull'
      SecretsManager::Cli::Pull.new(options).run
    end

    # secrets-manager read
    desc "read [name]", "Read specific secret"
    method_option 'environment',
      aliases: ['-e'],
      default: 'development',
      desc: 'Specify current environment'
    method_option 'profile',
      default: 'default',
      desc: 'Specify AWS profile'
    method_option 'path',
      aliases: ['-p'],
      default: 'secrets.json',
      desc: 'Specify a json configuration file path'

    def read(name)
      say "Contents of '#{name}' secret:", :green

      require 'secrets_manager/cli/read'
      puts SecretsManager::Cli::Read.new(options.merge(name: name)).run
    end

    # secrets-manager create
    desc "create", "Create new secret"
    method_option 'name',
      desc: 'Specify secret name'
    method_option 'desc',
      desc: 'Specify secret description'
    method_option 'secrets-file',
      desc: "Specify path to file with secret's content"
    method_option 'profile',
      default: 'default',
      desc: 'Specify AWS profile'

    def create
      say 'Creating new secret...', :green

      user_input = {}
      unless options[:name]
        user_input[:name] = ask 'Enter secret name [REQUIRED]:', :yellow
        if user_input[:name].empty?
          say 'Sorry, secret name is required.', :red
          exit 0
        end
      end
      unless options[:desc]
        user_input[:desc] = ask 'Enter secret description [OPTIONAL]:', :yellow
      end
      unless options[:secrets_file]
        user_input[:secrets_string] = ask "Enter secret's content [OPTIONAL]:", :yellow
      end

      require 'secrets_manager/cli/create'
      SecretsManager::Cli::Create.new(options.merge(user_input)).run
    end

    # TODO: secrets-manager diff
    # TODO: secrets-manager delete
    # TODO: secrets-manager update
    # TODO: secrets-manager update-value

    # secrets-manager version
    desc "version", "Get current gem version"
    def version
      require 'secrets_manager/version'
      puts SecretsManager::VERSION
    end
  end
end
