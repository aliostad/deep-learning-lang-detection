import yaml

from branch import Branch
from repository import Repository
from revision import Revision

# maximum YAML length, currently set to 1 megabyte
MAX_YAML_LENGTH = 1048576

# keys to repository
REPOSITORY_KEY = 'repository'
REPOSITORY_BRANCHES = 'branches'
REPOSITORY_PATH = 'path'
REPOSITORY_REVISIONS = 'revisions'

# keys to branch
BRANCH_KEY = 'branches'
BRANCH_HEAD = 'head'

# keys to revision
REVISION_PREDECESSORS = 'predecessors'
REVISION_PROPERTIES = 'properties'
REVISION_DIFFWITHPARENT = 'diffwithparent'

def construct_repository(path, key=None):
    """ read_yaml takes a path to a yaml file """
    fsock = open(path)
    
    repository = None
    try:
        # read the entire file into yaml_string
        yaml_string = fsock.read(MAX_YAML_LENGTH)
        yaml_rep = yaml.load(yaml_string)
    
        # create repository object from YAML
        repository = process_repository(yaml_rep[REPOSITORY_KEY])
        process_branch(yaml_rep[BRANCH_KEY], repository)
    
    finally:
        fsock.close()
    
    if key:
        return repository[key]
    else:
        return repository


def process_repository(repo_dict):
    """ Takes a dictionary containing keys: path, branches and revisions and 
    returns a Repository object. This method should only be called by 
    read_yaml. """
    path = repo_dict[REPOSITORY_PATH]
    revisions = {}
    if REPOSITORY_REVISIONS in repo_dict:
        for revision_id in repo_dict[REPOSITORY_REVISIONS]:
            revisions[revision_id] = None

    branches = {}
    # if the fixture has branches defined, set them to be None
    if REPOSITORY_BRANCHES in repo_dict:
        for branch_name in repo_dict[REPOSITORY_BRANCHES]:
            branches[branch_name] = None
    
    return Repository(path, branches, revisions, True)

def process_branch(branch_dict, repo):
    """ Takes a dictionary that has branch names as keys. This method sets
    branches for repo"""
    for branch_name in branch_dict:
        branch = branch_dict[branch_name]
        repo.get_branches()[branch_name] = Branch(branch[BRANCH_HEAD], branch_name)

def process_revision(revision_dict, repo):
    """ Takes a dictionary that has revision ids as keys. This method sets 
    revisions for repo"""
    for revision_id in revision_dict:
        revision = revision_dict[revision_id]
        
        predecessors = []
        if REVISION_PREDECESSORS in revision:
            predecessors = revision[REVISION_PREDECESSORS]
            
        properties = None
        if REVISION_PROPERTIES in revision:
            properties = revision[REVISION_PROPERTIES]
        
        diffwithparent = None
        if REVISION_DIFFWITHPARENT in revision:
            diffwithparent = revision[REVISION_DIFFWITHPARENT]
            
        repo.get_revisions()[revision_id] = Revision(predecessors, properties, diffwithparent) 
    