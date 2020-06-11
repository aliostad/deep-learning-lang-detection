require 'rspec'
require 'rspec/core/formatters'
require 'rspec/core/shared_context'
require_relative 'background_process'
require_relative 'process_pool'

# Just methods
# config.include BackgroundProcessCoreHelpers
module BackgroundProcessCoreHelpers
	def process_pool(options = {})
		@@process_pool ||= RSpecBackgroundProcess::ProcessPool.new(options)
	end

	def background_process(path, options = {})
		RSpecBackgroundProcess::ProcessPool::ProcessDefinition.new(
			process_pool.pool,
			options[:group] || 'default',
			path,
			options[:load] ? RSpecBackgroundProcess::LoadedBackgroundProcess : RSpecBackgroundProcess::BackgroundProcess,
			process_pool.options
		)
	end

	def self.report_failed_instance
		return unless defined? @@process_pool

		@@process_pool.report_failed_instance
		@@process_pool.report_logs
	end

	def self.report_pool_stats
		return unless defined? @@process_pool

		@@process_pool.report_stats
	end
end

# RSpec specific cleanup
# config.include BackgroundProcessHelpers
module BackgroundProcessHelpers
	extend RSpec::Core::SharedContext
	include BackgroundProcessCoreHelpers

	after(:each) do
		@@process_pool.cleanup
	end
end

# RSpec custom reporter
# config.add_formatter FailedBackgroundProcessReporter
class FailedBackgroundProcessReporter
	RSpec::Core::Formatters.register self, :example_failed

	def initialize(output)
		@output = output
	end

	def example_failed(example)
		@output << BackgroundProcessCoreHelpers.report_failed_instance
	end
end

# RSpec setup
RSpec.configure do |config|
	config.include BackgroundProcessHelpers, with: :background_process
	config.add_formatter FailedBackgroundProcessReporter
end

# Cucumber setup
if respond_to?(:World) and respond_to?(:After)
	World(BackgroundProcessCoreHelpers)

	After do
		process_pool.cleanup
	end

	After do |scenario|
		if scenario.failed?
			BackgroundProcessCoreHelpers.report_failed_instance
		end
	end
end

## To configure pool in Cucumber add this to env.rb
# Before do
#   process_pool(
#     logging: true,
#     max_running: 16
#   )
# end

## To report pool/LRU statistics at exit add this to env.rb
# at_exit do
#   BackgroundProcessCoreHelpers.report_pool_stats
# end
