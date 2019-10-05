require 'aws-sdk-secretsmanager'
require 'secrets_manager/error_handling'

module SecretsManager
  class Client
    include SecretsManager::ErrorHandling

    def initialize(profile = 'default')
      @profile = profile
    end

    def client
      @client ||= Aws::SecretsManager::Client.new(profile: @profile)
    end

    def get_secret_string(secret_id)
      client.get_secret_value(secret_id: secret_id).secret_string
    rescue Aws::SecretsManager::Errors::ServiceError
      raise_error(:aws_service_error, { secret_id: secret_id })
    end

    def get_secret_hash(secret_id)
      secret_string = get_secret_string(secret_id)

      return {} if secret_string.nil?

      JSON.parse(secret_string)
    rescue JSON::ParserError
      raise_error(:json_parse_error, { secret_id: secret_id })
    end

    def create_secret(params)
      client.create_secret(params)
    end
  end
end
