from spire.mesh import ModelController
from spire.schema import SchemaDependency

from lattice.server.resources import Project as ProjectResource
from lattice.server.models import *

class ProjectController(ModelController):
    resource = ProjectResource
    version = (1, 0)

    model = Project
    mapping = 'id status description'
    schema = SchemaDependency('lattice')

    def _annotate_model(self, model, data):
        repository = data.get('repository')
        if repository:
            model.repository = ProjectRepository.polymorphic_create(repository)

    def _annotate_resource(self, model, resource, data):
        repository = model.repository
        if repository:
            if repository.type == 'git':
                resource['repository'] = {'type': 'git', 'url': repository.url}
            elif repository.type == 'svn':
                resource['repository'] = {'type': 'svn', 'url': repository.url}
