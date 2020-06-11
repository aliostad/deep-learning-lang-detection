require_relative 'spec_helper'

describe BackgroundProcessHelpers, with: :background_process do
	describe '#process_pool' do
		it 'should provide singleton pool object ' do
			expect {
				process_pool
			}.not_to change {
				process_pool
			}
		end
	end

	describe '#background_process' do
		it 'should allow specifying executable to run' do
			process = background_process('features/support/test_process')
			expect(process.instance.command).to include 'features/support/test_process'
		end

		describe 'load option' do
			it 'when set to true will change instance type to LoadedBackgroundProcess' do
				process = background_process('features/support/test_process', load: true)
				expect(process.instance).to be_a RSpecBackgroundProcess::LoadedBackgroundProcess
			end
		end

		it 'should return process definition' do
			process = background_process('features/support/test_process')
			expect(process).to be_a RSpecBackgroundProcess::ProcessPool::ProcessDefinition
		end
	end
end
