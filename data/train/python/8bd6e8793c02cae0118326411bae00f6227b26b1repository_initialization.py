from resource_management import *
import json

_UBUNTU_REPO_COMPONENTS_POSTFIX = ['main']

def _alter_repository(action, repository_info, repository_template):
    repository_info = json.loads(repository_info)

    if not isinstance(repository_info, list):
        repository_info = [repository_info]

    for repository in repository_info:
        if not 'baseUrl' in repository:
            repository['baseUrl'] = None
        if not 'mirrorsList' in repository:
            repository['mirrorsList'] = None

        ubuntu_components = [ repository['repoName'] ] + _UBUNTU_REPO_COMPONENTS_POSTFIX

        Repository(repository['repoId'],
            action = action,
            base_url = repository['baseUrl'],
            mirror_list = repository['mirrorsList'],
            repo_file_name = repository['repoName'],
            repo_template = repository_template,
            components = ubuntu_components
        )

def create_repositories():
    import params

    template = "suse_rhel_repo.j2" if System.get_instance().os_family in ['suse', 'redhat'] else 'ubuntu_repo.js'

    _alter_repository('create', params.repo_info, template)

    if params.service_repo_info:
        _alter_repository('create', params.service_repo_info, template)
