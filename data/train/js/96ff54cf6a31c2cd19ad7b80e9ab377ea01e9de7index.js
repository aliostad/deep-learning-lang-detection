var express = require('express');
var userApiRouter = require('./user-api-router');
var bookmarkApiRouter = require('./bookmark-api-router');
var stackApiRouter = require('./stack-api-router');
var commentApiRouter = require('./comment-api-router');
var tagApiRouter = require('./tag-api-router');


module.exports = (function() {
    var apiRouter = express.Router();
    
    apiRouter.use('/users', userApiRouter);
    apiRouter.use('/bookmarks', bookmarkApiRouter);
    apiRouter.use('/stacks', stackApiRouter);
    apiRouter.use('/comments', commentApiRouter);
    apiRouter.use('/tags', tagApiRouter);

    return apiRouter;
})();