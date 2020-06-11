
# ===============================================
# Imports
# ===============================================
import cherrypy

from Root import Root
from src.python.recipe.RecipeController import RecipeController
from src.python.ingredient.IngredientController import IngredientController

# ===============================================
# Main
# ===============================================
if __name__ == '__main__':

  rootPage      		= Root()
  rootPage.recipe 		= RecipeController()
  rootPage.ingredient	= IngredientController()

  cherrypy.quickstart(rootPage, '/api', config=rootPage.config)