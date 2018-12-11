require 'aws-sdk-secretsmanager'

module SecretsManager
  class Client
    def initialize
      @client = Aws::SecretsManager::Client.new
    end

    def read_secret_string(secret_id)
      @client.get_secret_value(secret_id: secret_id).secret_string
    end

    def read_secret_json(secret_id)
      JSON.parse(@client.get_secret_value(secret_id: secret_id).secret_string)
    end
  end
end
