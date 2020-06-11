Fabricator(:repository) do
  name 'Greg Graffin'

  before_create do
    repository_path = Git::create_new_repository(Dir.mktmpdir(nil, Dir.tmpdir()))
    git = Git.new(repository_path)

    git.change_file 'first_file'
    git.commit_file 'first_file', 'first commit in master'
    git.change_file 'first_file'
    git.commit_file 'first_file', 'second commit in master'

    git.change_file 'second_file'
    git.commit_file 'second_file', 'third commit in master'

    self.path = repository_path
  end

end

def make_two_commits repository
  git = Git.new(repository.path)
  git.change_file 'first_file'
  git.commit_file 'first_file', '1 commited'
  git.change_file 'first_file'
  git.commit_file 'first_file', '2 commited'
end

Fabricator(:repository_with_builds, from: :repository) do
  after_create do
    repository = self
    repository.open
    repository.refresh_branches
    Branch.where(repository: repository).update_all(build: true)
    repository.refresh_all_commits

    make_two_commits repository

    repository.refresh_all_commits
  end
end