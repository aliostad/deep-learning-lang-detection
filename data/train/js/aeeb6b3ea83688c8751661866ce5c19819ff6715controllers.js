define(['albumController', 'categoryController', 'commentController', 'likeController',
         'logController', 'navigationController', 'photoController', 'userController'], 
         function(AlbumController, CategoryController, CommentController, LikeController,
             LogController, NavigationController, PhotoController, UserController) {

    return {
        getControllers: function (data) {
            return {
                categoryController: new CategoryController(data),
                logController: new LogController(data),
                albumController: new AlbumController(data),
                photoController: new PhotoController(data),
                navigationController: new NavigationController(data),
                commentController: new CommentController(data),
                likeController: new LikeController(data),
                userController: new UserController(data)
            }
        }
    }
});