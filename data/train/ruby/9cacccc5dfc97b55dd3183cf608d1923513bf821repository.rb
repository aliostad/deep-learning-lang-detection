require "sinatra/captcha"

require "selfmodifier/models/repository"

require "httpclient"

# TODO send a bug report to sinatra/captcha maintainer asking for alt
module Sinatra

	module Captcha
		# A valid XHTML version of captcha_image_tag
		def valid_captcha_image_tag
			"<input name=\"captcha_session\" type=\"hidden\" value=\"#{captcha_session}\"/>\n" +
				"<img id=\"captcha-image\" alt=\"CAPTCHA\" src=\"http://captchator.com/captcha/image/#{captcha_session}\"/>"
		end
	end
end

module SelfModifier

	class App

		include Sinatra::Captcha

		# Form to add new repository
		get "/repository/add" do
			haml :repository, :locals => {:title => "Add repository"}
		end

		# There was an error adding the repository
		def repository_error abstract, reason
			haml :repository, :locals => {
				:title => abstract,
				:message => reason,
				:username => params[:username],
				:repository => params[:repository]
			}
		end

		# The repository is invalid
		def invalid_repository
			status 403
			repository_error "Invalid repository", "The repository was not added, because the user and/or repository names were invalid."
		end

		# The repository was already in the portal
		def repository_already_present
			status 409
			repository_error "Repository already exists.", "The repository was already in the database."
		end

		# The captcha was bad
		def bad_captcha
			status 401
			repository_error "Bad captcha", "You did not fill out the captcha correctly."

		end

		# GitHub thinks this repository does not exist.
		def github_refuse
			status 404
			repository_error "Cannot find repository", "Either the repository doesn't exist or GitHub is experiencing problems."
		end

		# Try to save the repository
		def unsafe_save_repository username, repository
			repo = Repository.new :user => username, :project => repository
			if repo.save
				redirect "/"	
			else
				repository_already_present	
			end
		end

		# A new repository is to be added
		post "/repository/add" do
			if captcha_pass?
				username = params[:username]
				repository = params[:repository]
				# Test these are legal github user and repository names
				# Prevent arbitrary links :)
				if /^\w(-|\w)*$/.match(username) and /^(-|\w|\.)+$/.match(repository)

					# So the username and repository are okay.  Try to see if the project actually exists.
					client = HTTPClient.new
					exists = client.head("https://github.com/#{username}/#{repository}").code == 200
					if exists
						unsafe_save_repository username, repository
					else
						github_refuse	
					end
				else
					invalid_repository
				end
			else
				bad_captcha	
			end
		end

	end
end
