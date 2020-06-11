import datetime

from kalibro_client.processor import Repository

repository = Repository()
repository.id = 1
repository.name = 'repository name'
repository.scm_type = 'github'
repository.address = 'https://github.com/repository-name'
repository.description = 'repository description'
repository.license = 'license'
repository.period = 1
repository.created_at = datetime.datetime(2015, 9, 7, 18, 20, 18, 888000)
repository.updated_at = datetime.datetime(2015, 9, 7, 18, 20, 18, 888000)
repository.branch = 'master'

repositories = [repository]
