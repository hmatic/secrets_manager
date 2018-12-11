require 'json'

module SecretsManager
  class Config
    attr_reader :secrets

    def initialize(config_path, environment)
      @config_path = config_path
      @environment = environment
      @secrets = []
    end

    def init
      return unless File.file?(@config_path)

      configuration = JSON.parse(config_string, symbolize_names: true)
      configuration.each do |k, v|
        @secrets << SecretConfig.new(k, v[:id], v[:input], v[:type], v[:path])
      end

      self
    end

    def config_string
      File.read(@config_path).gsub('$environment', @environment)
    end

    class SecretConfig
      attr_reader :name, :id, :input, :type, :path

      def initialize(name, id, input, type, path)
        @name = name
        @id = id
        @input = input || 'json'
        @type = type || 'env'
        @path = path || 'config/application.yml'
      end

    end
  end
end
