require 'pathname'

module SecretsManager
  module Helpers
    def write_to_file(content, file_path)
      Pathname(file_path).dirname.mkpath
      File.open(File.join(Dir.pwd, file_path), 'w') do |f|
        f.puts content
      end
    end
  end
end
