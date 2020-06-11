Given(/^I have an independent repository$/) do
  @independent_repository = FactoryGirl.create(:repository, project_id: nil)
end

Given(/^the given project has the following Repositories:$/) do |table|
  hash = table.hashes.first
  hash[:project_id] = @project.id
  hash[:kalibro_configuration_id] = @kalibro_configuration.id

  @repository = FactoryGirl.create(:repository, hash)
end

Given(/^I have the given repository:$/) do |table|
  repository_attrs = table.hashes.first
  @repository = FactoryGirl.create(:repository, repository_attrs)
end

When(/^I call the cancel_process method for the given repository$/) do
  @response = @repository.cancel_processing_of_repository
end

When(/^I ask for repositories from the given project$/) do
  @response = KalibroClient::Entities::Processor::Repository.repositories_of(@project.id)
end

When(/^I call the process method for the given repository$/) do
  @response = @repository.process
end

When(/^I list types$/) do
  @repository_types = KalibroClient::Entities::Processor::Repository.repository_types
end

When(/^I ask for all the repositories$/) do
  @response = KalibroClient::Entities::Processor::Repository.all
end

When(/^I ask to find the given repository$/) do
  @response = KalibroClient::Entities::Processor::Repository.find(@repository.id)
end

When(/^I ask to check if the given repository exists$/) do
  @response = KalibroClient::Entities::Processor::Repository.exists?(@repository.id)
end

When(/^I ask for branches on a "(.*?)" repository with url "(.*?)"$/) do |scm_type, url|
  @branch_list = KalibroClient::Entities::Processor::Repository.branches(url, scm_type)
end

Then(/^I should get success$/) do
  expect(@response).to be_truthy
end

Then(/^I should get a list with the given repository$/) do
  expect(@response).to include(@repository)
end

Then(/^I should get an array of types$/) do
  expect(@repository_types).to be_a(Array)
  expect(@repository_types.count >= 1).to be_truthy
  expect(@repository_types).to include("GIT")
  expect(@repository_types).to include("SVN")
end

Then(/^I should get the given repository$/) do
  expect(@response).to eq(@repository)
end

Then(/^the response should contain the given repositories$/) do
  expect(@response).to include(@repository)
  expect(@response).to include(@independent_repository)
end

Then(/^the repositories should contain the project id$/) do
  expect(@response.first.project_id).to eq(@project.id)
end

When(/^I destroy the repository$/) do
  @repository.destroy
end

Then(/^the repository should no longer exist$/) do
  expect(KalibroClient::Entities::Processor::Repository.exists?(@repository.id)).to be_falsey
end

Then(/^the branch list should include "(.*?)"$/) do |name|
  expect(@branch_list["branches"]).to include(name)
end

Then(/^it should return an error as reponse$/) do
  expect(@branch_list["errors"]).to_not be_nil
end
