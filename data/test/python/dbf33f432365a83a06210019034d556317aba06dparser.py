import re


class Parser(object):
    # json data with job parameters
    __json_data = {}

    def __init__(self, json_data):
        self.__json_data = json_data

    def get_repository_namespace(self):
        repository_name = ''
        if "repository" in self.__json_data and "homepage" in self.__json_data["repository"]:
            match = re.match("[^:]*:([^/]*).*", self.__json_data["repository"]["url"])
            repository_name = match.group(1)
        return repository_name

    def get_repository_url(self):
        repository_url = ''
        if "repository" in self.__json_data and "url" in self.__json_data["repository"]:
            repository_url = self.__json_data["repository"]["url"]
        return repository_url

    def get_branch_name(self):
        branch_name = ''
        if "ref" not in self.__json_data:
            return branch_name
        branch_name = re.match("refs/heads/(.*)", self.__json_data["ref"])
        return branch_name.group(1)

    def get_project_name(self):
        project_name = ''
        if "repository" in self.__json_data and "name" in self.__json_data["repository"]:
            project_name = self.__json_data["repository"]["name"]
        return project_name
