import sublime, sublime_plugin

class NotAGitRepositoryError(Exception):
 	pass

class NotAGithubRepositoryError(Exception):
	pass

class GitIssues:

	def __init__(self, path):
		self.path = path
		if not self.is_git():
			raise NotAGitRepositoryError
		self.repository_path = self.repository_path()

	def is_git(self):
		os.chdir(self.path)
		code = os.system('git rev-parse')
		return not code

	def repository_path(self):
		repository_path = self.parse_repository(self.git("remote -v"))
		if not repository_path:
			raise NotAGithubRepositoryError
		return repository_path