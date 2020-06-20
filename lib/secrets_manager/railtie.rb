require 'secrets_manager/config'
require 'secrets_manager/client'
require 'secrets_manager/helpers'

module SecretsManager
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      include SecretsManager::Helpers

      unless File.file?(Rails.root.join('config', 'application.yml'))
        puts 'Initializing secrets via Secrets Manager gem.'

        config_path = Rails.root.join('secrets.json')
        secrets_config = SecretsManager::Config.new(config_path, Rails.env).init
        puts 'Secrets.json file is missing.' if secrets_config.nil?

        aws_client = SecretsManager::Client.new

        secrets_config.secrets.each do |secret|
          next if File.file?(Rails.root.join(secret.path))

          if secret.plaintext? && secret.to_file?
            write_to_file(aws_client.get_secret_string(secret.id), secret.path)
          else
            aws_client.get_secret_hash(secret.id).each do |key, value|
              ENV[key.to_s] = value
            end
          end
        end
      end
    end
  end
end
