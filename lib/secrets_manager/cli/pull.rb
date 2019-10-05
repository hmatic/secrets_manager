require 'secrets_manager/cli/base'
require 'yaml'

module SecretsManager
  module Cli
    class Pull < Base

      private

      def execute
        config.secrets.each do |secret|
          write_to_file(secret_output(secret), secret.path) && success_msg(secret)
        end
      end

      def secret_output(secret)
        if secret.plaintext?
          client.get_secret_string(secret.id)
        elsif secret.yaml_output?
          client.get_secret_hash(secret.id).to_yaml[4..-1]
        elsif secret.json_output?
          JSON.pretty_generate(client.get_secret_hash(secret.id))
        else
          raise_error(:invalid_secret_config, { secret_id: secret.id })
        end
      end

      def success_msg(secret)
        puts "Pulled #{secret.name}(id: #{secret.id}) secret to \"#{secret.path}\"."
      end
    end
  end
end
