require 'secrets_manager/config'
require 'secrets_manager/client'
require 'secrets_manager/helpers'

module SecretsManager
  class Railtie < ::Rails::Railtie
    include SecretsManager::Helpers

    config.before_configuration do
      if secrets_config.rails_active?
        puts 'Initializing secrets via Secrets Manager gem.'

        secrets_config.secrets.each do |secret|
          if File.file?(Rails.root.join(secret.path))
            puts "File #{secret.path} already exists. Skipping secret..."
            next
          end

          if secret.json? && secret.to_env?
            inject_to_env(secret)
          elsif secret.plaintext? && secret.to_file?
            write_to_secrets_file(secret)
          else
            raise_error(:invalid_secret_config, { secret_id: secret_id })
          end
        end
      end
    end

    def secrets_config
      secrets_config ||= SecretsManager::Config.new(secrets_manager_config_path, Rails.env).init || raise_error(:config_missing)
    end

    def client
      client ||= SecretsManager::Client.new
    end

    def secrets_manager_config_path
      Rails.root.join('secrets.json')
    end

    def inject_to_env(secret)
      client.get_secret_hash(secret.id).each do |key, value|
        ENV[key.to_s] = value
      end
    end

    def write_to_secrets_file(secret)
      write_to_file(client.get_secret_string(secret.id), secret.path)
    end
  end
end
