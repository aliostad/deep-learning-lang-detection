import core.task
import os


class CloneTask(core.task.Task):
	def execute_task(self, parameters=None):
		self._check_mandatory_parameters(['repository_type', 'repository_path', 'clone_path'], parameters)
		repository_type = parameters['repository_type']
		repository_path = parameters['repository_path']
		clone_path = parameters['clone_path']

		if repository_type == 'svn':
			os.system("svn export --force %s %s" % (repository_path, clone_path))
		else:
			raise core.task.TaskParameterException('repository_type', 'unsupported repository type %s' % repository_type)	
