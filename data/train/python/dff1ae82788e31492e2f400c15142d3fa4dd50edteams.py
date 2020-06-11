'''
Created on 03-07-2013
'''
from bulbs.model import Node, Relationship
from bulbs.property import String, Integer, DateTime, None
from bulbs.utils import current_datetime

class Repository(Node):

    element_type = "team"

    
    repository_url = String(nullable=False)
    repository_has_downloads = None(nullable=True)
    repository_created_at = String(nullable=False)
    repository_has_issues = None(nullable=True)
    repository_description = String(nullable=True)
    repository_forks = Integer(nullable=True)
    repository_fork  = String(nullable=True)
    repository_has_wiki  = None(nullable=True)
    repository_homepage = String(nullable=True)
    repository_size = Integer(nullable=True)
    repository_private = String(nullable=True)
    repository_name = String(nullable=True)
    repository_owner = String(nullable=True)
    repository_open_issues = Integer(nullable=True)
    repository_watchers = Integer(nullable=True)
    repository_pushed_at = String(nullable=True)
    repository_language = String(nullable=True)
    repository_organization = String(nullable=True)
    repository_integrate_branch = String(nullable=True)
    repository_master_branch = String(nullable=True)
'''
@author: s4268
'''
