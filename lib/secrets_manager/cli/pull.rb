require 'secrets_manager/cli/base'
require 'aws-sdk-secretsmanager'
require 'json'

module SecretsManager
  module Cli
    class Pull < Base

      def run
        require 'pry'
        binding.pry
        puts config_path
      end

      private

      def execute
        config.secrets.each do |secret|
          secret_value = Aws::SecretsManager::Client.new.get_secret_value(secret_id: secret.name).secret_string
          pretty_secret = JSON.pretty_generate(JSON.parse(secret_value))
          output_file = secret.path
          write_to_file(pretty_secret, output_file)
        end
      end

    end
  end
end
