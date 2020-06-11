require 'spec_helper'

describe 'SignInProcess' do

	context 'with valid credentials' do
		
		it 'signs in the session' do
			@sign_in_process = FactoryGirl.build(:sign_in_process, :valid)
			@sign_in_process.execute
			@sign_in_process.process_result.ok?.should be_true	
		end

	end

	context 'with invalid credentials' do
		
		it 'signs in the session' do
			@sign_in_process = FactoryGirl.build(:sign_in_process, :invalid)
			@sign_in_process.execute
			@sign_in_process.process_result.ok?.should be_false	
		end

	end

end