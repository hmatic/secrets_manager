require 'secrets_manager/config'
require 'secrets_manager/client'

module SecretsManager
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      secret_config = SecretsManager::Config.new(Rails.root.join('secrets.json'), Rails.env)
      puts 'Secrets.json file is missing.' if secret_config.nil?
      aws_client = SecretsManager::Client.new

      secret_config.secrets.each do |secret|
        puts secret.id
        aws_client.read_secret_json(secret.id).each do |key, value|
          ENV[key.to_s] = value
        end
      end
    end
  end
end
