require 'pathname'

module SecretsManager
  module Helpers
    def write_to_file(content, file_path)
      return false if content.nil? || content.empty?

      Pathname(file_path).dirname.mkpath
      File.open(File.join(Dir.pwd, file_path), 'w') do |f|
        f.puts content
      end

      true
    end
  end
end
