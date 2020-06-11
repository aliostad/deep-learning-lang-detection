from repository.favoritesrepo import FavoritesRepository
from repository.git import set_logger
import random
from model.favorite import Favorite
import tabcontroller

model = None
repository = None 
logger = None
repositoryDirectory = ''

def start(mainviewModel):
    global model
    global repository
    global logger 
     
    model = mainviewModel
    logger = model.get_logger()
    set_logger(logger)
    
    model.tabs.set_logger(logger)
    repository = FavoritesRepository(logger)
    tabcontroller.start(model.tabs)

def new_repository(directory):
    # create the repository 
    result = repository.new_repo(directory)
    if(not result):
        logger.error(__name__, 'new_repository', 'repository was not created, stopping')
        return
    # add an example favorite 
    repository.add_favorite(directory, 'example', 'the title of the example')
    repository.save_favorite(directory, 'example', 'a new title')
    open_repository(directory)
    
def open_repository(directory):
    global repositoryDirectory
    repositoryDirectory = directory
    
    favorites = repository.get_favorites_root(directory)
    repository.sync(directory)
    #commit any changes on load 
    model.set_favorites(favorites)
    logger.set_commits(repository.get_commits(directory))
    
def add_child(node):
    logger.clear()
    
    name = str(random.randrange(100000))
    title = 'atitle'
    
    repository.add_favorite(repositoryDirectory, name, title,  node.getFullPath() + '/')

    favorite = Favorite(title, name)
    favorite.parent = node     
    
    logger.set_commits(repository.get_commits(repositoryDirectory))
    return favorite

def save(node, newTitle='', page = None):
    logger.clear()
    
    logger.info(__name__, 'save', node.to_string()) 
    
    if not newTitle == '':
        repository.save_favorite(repositoryDirectory, node.getFullPath(), newTitle)
    elif not page == None:
        repository.save_favorite(repositoryDirectory, node.getFullPath(), page = page)
        
    logger.set_commits(repository.get_commits(repositoryDirectory))
    
def rollback(commit = None):
    logger.clear()
    repository.rollback(repositoryDirectory, commit)
    open_repository(repositoryDirectory)
        
def delete(node):
    logger.clear()
    repository.delete_node(repositoryDirectory, node.getFullPath())
    logger.set_commits(repository.get_commits(repositoryDirectory))
    
def show_page(page):
    tabcontroller.show_page(page)