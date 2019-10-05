require 'secrets_manager/cli/base'
require 'yaml'

module SecretsManager
  module Cli
    class Read < Base

      private

      def execute
        secret = config.secrets.find { |secret| secret.name == @options[:name] }

        if secret.plaintext?
          puts client.get_secret_string(secret.id)
        elsif secret.yaml_output?
          puts client.get_secret_hash(secret.id).to_yaml[4..-1]
        elsif secret.json_output?
          puts JSON.pretty_generate(client.get_secret_hash(secret.id))
        else
          raise_error(:invalid_secret_config, { secret_id: secret.id })
        end
      end
    end
  end
end
