require 'secrets_manager/cli/base'
require 'yaml'

module SecretsManager
  module Cli
    class Create < Base

      private

      def execute
        secret_params = {}
        secret_params[:name] = options[:name]
        secret_params[:description] = options[:desc] unless options[:desc].to_s.empty?
        secret_params[:secret_string] = File.read(options[:secrets_file]) unless options[:secrets_file].to_s.empty?
        secret_params[:secret_string] = options[:secrets_string] unless options[:secrets_string].to_s.empty?

        response = client.create_secret(secret_params)

        puts colors.set_color "Created #{response.name} secret:", :green
        puts colors.set_color "arn: #{response.arn}", :yellow
        puts colors.set_color "version: #{response.version_id}", :yellow
      end
    end
  end
end
