#################################################################
#                  set up routing for website                   #
#################################################################


import webapp2
from google.appengine.ext.webapp import template
from webapp2_extras import sessions
import sys
import os.path


config = {}
config['webapp2_extras.sessions'] = {
    'secret_key': 'aklsdfnkanxcjkzbxfjkhadfsks',
}



class index(webapp2.RequestHandler):
    
    # start session    
    def dispatch(self):
        # Get a session store for this request.
        self.session_store = sessions.get_store(request=self.request)
 
        try:
            # Dispatch the request.
            webapp2.RequestHandler.dispatch(self)
        finally:
            # Save all sessions.
            self.session_store.save_sessions(self.response)
 
    @webapp2.cached_property
    def session(self):
        # Returns a session using the default cookie key.
        return self.session_store.get_session()

    
    
import controllers.indexController as indexController
import controllers.galleryController as galleryController
import controllers.profileController as profileController
import controllers.updateprofileController as updateprofileController
import controllers.userLogController as userController
import controllers.imageController as imageController
import controllers.tempClothController as tempClothController
import controllers.clothController as clothController

import models.imagesModel as imagesModel    
import models.clothModel as clothModel


# set up paths
mappings = [
    ('/', indexController.index),
    ('/gallery', galleryController.index),
    ('/profile', profileController.index),
    ('/updateprofile', updateprofileController.index),
    ('/updateprofileitems', updateprofileController.update),
    ('/user', userController.index),
    ('/userFunctions', userController.userFunctions),
    ('/uploadImage', imageController.uploadImageHandler),
    ('/addLike', imageController.addLikeHandler),
    ('/getLikes', imageController.getLikeHandler),
    ('/comment', imageController.addCommentHandler),
    ('/deleteComment', imageController.deleteCommentHandler),
    ('/getCommentsTest', imageController.getCommentsHandler),
    ('/unlike', imageController.deleteLikeHandler),
    ('/getPhotosJSON', imagesModel.getPhotosJSONHandler),
    ('/test', imagesModel.testGetImages),
    ('/tempCloth', tempClothController.index),
    ('/newUserSuccess', userController.newUserSuccess),
    ('/editItems', profileController.editItems),
    ('/addNewItemHandler', clothController.index),
    ('/getItems', clothModel.getItems),
    ('/setProfilePic', profileController.setProfilePic ),
    ('/deletePic', imageController.deletePicHandler)
#    ('/gallery', galleryController.gallery2)
#    ('/userLog', userController.loginPage.show)
]


app = webapp2.WSGIApplication(mappings, config=config, debug=True)




