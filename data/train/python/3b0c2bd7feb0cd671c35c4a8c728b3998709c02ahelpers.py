import models

def obj_to_dictionary(repository):
    if not repository:
        return None
    return {'name': repository.name,
            'description': repository.description,
            'url': repository.url,
            'graph_url': repository.graph_url}


def obj_to_tuple(repository):
    if not repository:
        return None
    return (repository.name,
            repository.description,
            repository.url,
            repository.graph_url)

def dict_to_tuple(repository):
    if not repository:
        return None
    return (repository['name'],
            repository['description'],
            repository['url'],
            repository['graph_url'])

def update_models(project_list, user):
    for project in project_list:
        update_model(project, user)

def update_model(project, user):
    proj_model = models.Project(name=project['name'],
                 description=project['description'],
                 url=project['url'],
                 graph_url=project['graph_url'],
                 key_name=user.username + "_" + project['name'])
    proj_model.put()

    if proj_model.key() not in user.projects:
        user.projects.append(proj_model.key())
        user.put()