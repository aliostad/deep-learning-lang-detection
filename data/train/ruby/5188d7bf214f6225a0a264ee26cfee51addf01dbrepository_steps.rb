require 'tmpdir'

def clone_repo(repository_url, revision = nil)
  @repository_path = Dir.mktmpdir

  cmd = ['git', 'clone', '-q', '--depth', '1', repository_url, @repository_path]
  cmd += ['-b', revision] if revision
  expect(system(*cmd, [:out, :err] => '/dev/null')).to be_truthy
end

Given(/^the "([^"]*)" repository is cloned$/) do |repository_url|
  clone_repo(repository_url)
end

Given(/^the "([^"]*)" repository is cloned with revision "([^"]*)"$/) do |repository_url, revision|
  clone_repo(repository_url, revision)
end
