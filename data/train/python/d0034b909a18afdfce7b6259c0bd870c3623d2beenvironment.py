from .base import Base
from .repository import Repository


class Environment(Base):

    def find(self, repository_id, environment_id=None):
        if environment_id:
            url = str(repository_id) + '/server_environments/' + str(environment_id) + '.json'
        else:
            url = str(repository_id) + '/server_environments.json'

        return self._do_get(url)

    def find_all(self, repository_id):
        return self.find(repository_id)

    def create(self, repository_id, name, branch_name, automatic=False):
        url = str(repository_id) + '/server_environments.json'
        data = {
            'server_environment': {
                "name": name,
                "automatic": automatic,
                "branch_name": branch_name
            }
        }
        return self._do_post(url, data)

    def update(self, repository_id, environment_id, update_data):
        url = str(repository_id) + '/server_environments/' + str(environment_id) + '.json'
        data = {
            'server_environment': update_data
        }
        return self._do_put(url, data)

    def find_by_repository_name(self, repository_name, environment_name=None):
        _repository = Repository()
        repository_id = _repository.get_id_by_name(repository_name)
        if repository_id is None:
            return None

        envs = self.find_all(repository_id)
        if environment_name is None:
            return envs
        for env in envs:
            if env['server_environment']['name'] == environment_name:
                return env

        return envs

    def get_id_by_name(self, repository_name, environment_name):
        env = self.find_by_repository_name(repository_name, environment_name)
        if env is not None:
            return env['server_environment']['id']

        return None
