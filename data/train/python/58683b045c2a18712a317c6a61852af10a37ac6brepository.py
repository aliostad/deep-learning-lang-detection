import requests
import json


class Repository:
    
    def __init__(self):
        self.datasets = []
    
    
    def list(self):
        return self.datasets
        
    

class GitHubRepository(Repository):
    
    def __init__(self, repository_type, username):
        Repository.__init__(self)
        
        repository_request_url = 'https://api.github.com/{}/{}/repos'.format(repository_type,username)
        
        r = requests.get(repository_request_url)
        
        if r.ok :
            github_datasets = json.loads(r.text or r.content)
            
            for dataset in github_datasets:
                identifier = url = dataset['clone_url']
                name = dataset['name']
                description = dataset['description']
                
                self.datasets.append({'identifier': identifier,
                                      'url': url,
                                      'name': name,
                                      'description': description})
        else :
            r.raise_for_status()
            

    
        
        
    
