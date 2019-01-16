require 'secrets_manager/config'
require 'secrets_manager/client'

module SecretsManager
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      unless File.file?(Rails.root.join('config', 'application.yml'))
        puts 'Initializing secrets via Secrets Manager gem.'

        config_path = Rails.root.join('secrets.json')
        secrets_config = SecretsManager::Config.new(config_path, Rails.env).init
        puts 'Secrets.json file is missing.' if secrets_config.nil?

        aws_client = SecretsManager::Client.new

        secrets_config.secrets.each do |secret|
          next if File.file?(Rails.root.join(secret.path))

          aws_client.get_secret_hash(secret.id).each do |key, value|
            ENV[key.to_s] = value
          end
        end
      end
    end
  end
end
