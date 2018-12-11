require 'secrets_manager/config'
require 'secrets_manager/helpers'

module SecretsManager
  module Cli
    class Base
      include SecretsManager::Helpers

      def initialize(options)
        @options = options
      end

      def run
        config.init
        execute
      end

      private

      def execute
        raise NotImplementedError
      end

      def config_path
        File.join(Dir.pwd, @options['path'])
      end

      def environment
        @options['environment']
      end

      def config
        @config ||= SecretsManager::Config.new(config_path, environment)
      end

    end
  end
end
