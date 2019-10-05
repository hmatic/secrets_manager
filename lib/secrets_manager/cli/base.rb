require 'secrets_manager/config'
require 'secrets_manager/client'
require 'secrets_manager/helpers'
require 'secrets_manager/error_handling'

module SecretsManager
  module Cli
    class Base
      include SecretsManager::Helpers
      include SecretsManager::ErrorHandling

      attr_reader :options, :client

      def initialize(options)
        @options = options
        @client = SecretsManager::Client.new(options[:profile])
      end

      def run
        config.init if options[:path]
        execute
      end

      private

      def execute
      end

      def config_path
        File.join(Dir.pwd, options['path'])
      end

      def environment
        options['environment']
      end

      def config
        @config ||= SecretsManager::Config.new(config_path, environment)
      end

      def colors
        @colors ||= Thor::Shell::Color.new
      end
    end
  end
end
