require 'json'

module SecretsManager
  class Config
    attr_reader :secrets

    def initialize(config_path, environment)
      @config_path = config_path
      @environment = environment
      @rails = false
    end

    def init
      return unless File.file?(@config_path)

      @secrets = []
      configuration = load_config

      @rails = configuration[:rails]

      configuration[:secrets].each do |secret|
        @secrets << SecretConfig.new(
          secret[:name],
          secret[:id],
          secret[:secret_type],
          secret[:inject_to],
          secret[:path]
        )
      end

      self
    end

    def rails_active?
      @rails
    end

    def load_config
      JSON.parse(File.read(@config_path).gsub('$environment', @environment), symbolize_names: true)
    end

    class SecretConfig
      attr_reader :name, :id, :secret_type, :inject_to, :path

      DEFAULT_SECRET_TYPE = 'json'
      DEFAULT_INJECT_TO = 'env'
      DEFAULT_PATH = 'config/application.yml'

      def initialize(name, id, secret_type, inject_to, path)
        @name = name
        @id = id
        @secret_type = secret_type || DEFAULT_SECRET_TYPE
        @inject_to = inject_to || DEFAULT_INJECT_TO
        @path = path || DEFAULT_PATH
      end

      def plaintext?
        secret_type == 'plaintext'
      end

      def json?
        secret_type == 'json'
      end

      def to_env?
        inject_to == 'env'
      end

      def to_file?
        inject_to == 'file'
      end

      def yaml_output?
        path.strip.end_with?('.yml', '.yaml')
      end

      def json_output?
        path.strip.end_with? '.json'
      end
    end
  end
end
