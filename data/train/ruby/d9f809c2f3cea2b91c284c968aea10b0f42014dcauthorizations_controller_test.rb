require 'test_helper'

describe AuthorizationsController do

	before :each do
		Rails.cache.clear
		@user = create(:user, twi_user_id: 1, role: 'moderator')
		@wisr_asker = Asker.find(8765)
	end

	describe 'by token authentication' do
		include AuthorizationsHelper

		before :each do
			Capybara.current_driver = :selenium
			@url = "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}"
		end

		describe 'logs user in' do
			it 'to proper page for moderator' do
				auth_mod_manage = authenticated_link("/moderations/manage",
					@user,
					(Time.now + 1.week))

				visit auth_mod_manage

				current_path.must_equal '/moderations/manage'
			end

			it 'to proper page for return author' do
				auth_mod_manage = authenticated_link("/askers/#{@wisr_asker.id}/questions", @user, (Time.now + 1.week))
				visit auth_mod_manage
				current_path.must_equal "/askers/#{@wisr_asker.id}/questions"
			end

			it 'maintains other url parameters' do
				auth_mod_manage = authenticated_link("/moderations/manage?s=twi&t=user_name", @user, (Time.now + 1.week))
				visit auth_mod_manage
				params = Rack::Utils.parse_query(URI(current_url).query)
				params["s"].must_equal 'twi'
				params["t"].must_equal 'user_name'
			end

			it 'unless no token authentication information passed' do
				visit '/moderations/manage'
				current_path.must_equal '/oauth/authenticate'
			end

			it 'unless no user with authentication token found' do
				auth_mod_manage = authenticated_link("/moderations/manage?s=twi&t=user_name", @user, (Time.now + 1.week))
				@user.update_attribute :authentication_token, @user.reset_authentication_token
				visit auth_mod_manage
				current_path.must_equal '/oauth/authenticate'
			end

			it 'unless link is expired' do
				## NOTE: there's a conflict with timecop and omniauth - the timestamp associated w/ the auth
				## request is set to a future time and twi rejects it + returns a 401 before redirecting to
				## from /users/auth/twitter to /oauth/authenticate.
				auth_mod_manage = authenticated_link("/moderations/manage", @user, (Time.now + 3.days))
				3.times do |i|
					# Capybara.reset_session! # using reset_session! results in periodic 401 errors when running the full suite
					session = Capybara::Session.new(:selenium)
					Timecop.travel(Time.now + 1.day)
					session.visit "#{@url}#{auth_mod_manage}"
					if i < 2
						session.current_path.must_equal '/moderations/manage'
					else
						session.current_path.must_equal '/users/auth/twitter'
					end
				end
			end

			it "cookie isn't expired after successful authentication" do
				auth_mod_manage = authenticated_link("/moderations/manage", @user, (Time.now + 3.days))
				visit auth_mod_manage
				current_path.must_equal '/moderations/manage'
				Timecop.travel(Time.now + 11.months)
				visit auth_mod_manage
				current_path.must_equal '/moderations/manage'
				Timecop.travel(Time.now + 13.months)

				visit auth_mod_manage
				current_path.wont_equal '/moderations/manage'
			end

			it 'retains authentication for other pages that require authentication' do
				auth_mod_manage = authenticated_link("/moderations/manage", @user, (Time.now + 3.days))
				visit auth_mod_manage
				visit "/askers/#{@wisr_asker.id}/questions"
				current_path.must_equal "/askers/#{@wisr_asker.id}/questions"
			end
		end
	end
end
