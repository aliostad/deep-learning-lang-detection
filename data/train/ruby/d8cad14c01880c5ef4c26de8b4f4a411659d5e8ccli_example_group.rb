require 'in_process'

module RSpec
  module CliExampleGroup
    def self.included(base)
      base.class_eval do
        ::InProcess.main_class = Mindwork::CLI::MyMain
        metadata[:type] = :cli

        let(:command) do
          {}
        end

        let(:process) do
          process = InProcess.new(command.to_s, nil, nil)
          process.run!
          process
        end

        let(:stdout) do
          process.stdout
        end

        let(:stderr) do
          process.stderr
        end
      end
    end

    RSpec.configure do |config|
      config.include self,
        :type => :cli,
        :example_group => { :file_path => %r(spec/lib/mindwork/cli) }
    end
  end
end
