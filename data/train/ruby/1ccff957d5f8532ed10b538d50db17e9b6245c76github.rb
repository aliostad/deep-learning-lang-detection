require "selfmodifier/models/repository"

require "rainbow"

Then /^a github repository, (.+)\/(.+) is added$/ do |username, repository|
	with_selenium do |sel|
		sel.open "/repository/add"
		sel.type "username", username
		sel.type "repository", repository
		puts "\a"
		puts "Please fill out the captcha:".foreground 255, 100, 100
		sel.type "captcha_answer", STDIN.gets 
		sel.click "add"
		sel.wait_for_page 10
	end
end

Then /^a repository for (.+)\/(.+) is in the database$/ do |username, repository|
	unless Repository.find_by_user_and_project(username, repository)
		raise "Repository not in database: #{username}/#{repository}"
	end
end

Then /^a repository for (.+)\/(.+) is not in the database$/ do |username, repository|
	if Repository.find_by_user_and_project(username, repository)
		raise "Repository in database: #{username}/#{repository}"
	end

end
