from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from app.get_story import getStory
from app.save_story import saveStory, saveStoryWorker
from app.pages import frontPage, storyViewer

routes = [
  ('/ajax/save_story', saveStory),
  ('/ajax/get_story', getStory),
  ('/worker/save_story', saveStoryWorker),
  ('/', frontPage),
  (r'.*', storyViewer)
]

application = webapp.WSGIApplication(routes, debug=True)

def main():
  run_wsgi_app(application)

if __name__ == "__main__":
  main()
