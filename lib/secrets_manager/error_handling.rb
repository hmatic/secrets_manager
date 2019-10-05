module SecretsManager
  module ErrorHandling
    def raise_error(error, options = nil)
      # prefix option keys with $
      options.keys.each { |k| options["$#{k}"]= options.delete(k) }

      # interpolate $variables with values from options argument
      error_output = send(error).map { |el| el.gsub(/\$[\w_]+/, options) }

      puts error_output
    end

    def json_parse_error
      [
        'Could not parse JSON in $secret_id secret. Please check your secret contents.',
        'You can also define your secret type as "plaintext".'
      ]
    end

    def aws_service_error
      [
        'Could not retrieve $secret_id secret from AWS.',
        'Please check you configured everything correctly.'
      ]
    end

    def config_missing
      [
        'Secrets.json file is missing.',
        'Please it in root of your project directory.'
      ]
    end

    def invalid_secret_config
      [
        "Secret '$secret_id' has invalid configuration."
      ]
    end
  end
end
