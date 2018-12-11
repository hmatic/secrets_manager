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
      # require "secrets_manager/cli/pull"
      # Pull.start
    end

    # figaro heroku:set

    # desc "heroku:set", "Send Figaro configuration to Heroku"

    # method_option "app",
    #   aliases: ["-a"],
    #   desc: "Specify a Heroku app"
    # method_option "environment",
    #   aliases: ["-e"],
    #   desc: "Specify an application environment"
    # method_option "path",
    #   aliases: ["-p"],
    #   default: "config/application.yml",
    #   desc: "Specify a configuration file path"
    # method_option "remote",
    #   aliases: ["-r"],
    #   desc: "Specify a Heroku git remote"

    # define_method "heroku:set" do
    #   require "figaro/cli/heroku_set"
    #   HerokuSet.run(options)
    # end
  end
end