require 'secrets_manager/config'
require 'secrets_manager/client'
require 'secrets_manager/helpers'

module SecretsManager
  module Cli
    class Base
      include SecretsManager::Helpers

      attr_reader :client

      def initialize(options)
        @options = options
        @client = SecretsManager::Client.new
      end

      def run
        config.init
        execute
      end

      private

      def execute
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
