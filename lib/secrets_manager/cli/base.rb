require 'secrets_manager/config'
require 'pathname'

module SecretsManager
  module Cli
    class Base
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

      def write_to_file(content, file_path)
        Pathname(file_path).dirname.mkpath
        File.open(File.join(Dir.pwd, file_path), 'w') do |f|
          f.puts content
        end
      end

    end
  end
end
