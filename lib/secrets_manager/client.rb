require 'aws-sdk-secretsmanager'

module SecretsManager
  class Client
    def initialize
      @client = Aws::SecretsManager::Client.new
    end

    def get_secret_string(secret_id)
      @client.get_secret_value(secret_id: secret_id).secret_string
    rescue Aws::SecretsManager::Errors::ServiceError
      aws_error(secret_id)
    end

    def get_secret_hash(secret_id)
      return if (secret_string = get_secret_string(secret_id)).nil?

      JSON.parse(secret_string)
    rescue JSON::ParserError
      json_parsing_error(secret_id)
    end

    def json_parsing_error(secret_id)
      puts "Could not parse JSON in \"#{secret_id}\" secret. Please check your secret contents."
      puts 'You can also define your secret type as "plaintext".'
    end

    def aws_error(secret_id)
      puts "Could not retrieve \"#{secret_id}\" secret from AWS. Please check you configured everything correctly."
    end
  end
end
