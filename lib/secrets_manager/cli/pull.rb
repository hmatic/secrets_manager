require 'secrets_manager/cli/base'
require 'yaml'

module SecretsManager
  module Cli
    class Pull < Base

      private

      def execute
        config.secrets.each do |secret|
          write_to_file(output(secret), secret.path) && sucess_msg(secret)
        end
      end

      def output(secret)
        return client.get_secret_string(secret.id) if secret.plaintext?

        secret_hash = client.get_secret_hash(secret.id)

        return if secret_hash.nil?
        return secret_hash.to_yaml[4..-1] if secret.yaml_output?
        return JSON.pretty_generate secret_hash if secret.json_output?
      end

      def sucess_msg(secret)
        puts "Pulled \"#{secret.id}\" secret to \"#{secret.path}\"."
      end
    end
  end
end
