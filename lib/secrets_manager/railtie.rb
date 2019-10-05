require 'secrets_manager/config'
require 'secrets_manager/client'

module SecretsManager
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      unless File.file?(Rails.root.join('config', 'application.yml'))
        puts 'Initializing secrets via Secrets Manager gem.'

        secrets_config.secrets.each do |secret|
          if File.file?(Rails.root.join(secret.path))
            puts "File #{secret.path} already exists. Skipping secret..."
            next
          end

          client.get_secret_hash(secret.id).each do |key, value|
            ENV[key.to_s] = value
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
  end
end
