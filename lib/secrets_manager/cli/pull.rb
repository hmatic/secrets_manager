require 'secrets_manager/cli/base'
require 'aws-sdk-secretsmanager'
require 'yaml'

module SecretsManager
  module Cli
    class Pull < Base

      private

      def execute
        config.secrets.each do |secret|
          secret_value = Aws::SecretsManager::Client.new.get_secret_value(secret_id: secret.id).secret_string
          yaml_secret = JSON.parse(secret_value).to_yaml[4..-1]
          output_file = secret.path
          write_to_file(yaml_secret, output_file)
        end
      end

    end
  end
end
