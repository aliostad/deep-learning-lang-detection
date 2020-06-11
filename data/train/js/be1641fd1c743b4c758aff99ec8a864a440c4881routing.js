
    var routeMain = require('./main');
    var routeApi = require('./api');
    var routeApiComments = require('./api_comments');
    var routeApiFiles = require('./api_files');
    var routeApiMessages = require('./api_messages');
    var routeApiPosts = require('./api_posts');
    var routeApiUsers = require('./api_users');
    var routeApiVotes = require('./api_votes');
    
    app.all('*', routeMain.parseRequestData);
    
    
    app.get('/', routeMain.main );
    app.get('/strings.js', routeMain.main_strings );

    app.all('/api' , routeApi.docs);
    app.all('/api/develop' , routeApi.develop);
    
    
    

    app.get('/api/user', routeApiUsers.load ); //OK 
    app.get('/api/user/status', routeApiUsers.status ); 
    app.post('/api/user/signup', routeApiUsers.signup ); //OK
    app.post('/api/user/login', routeApiUsers.login ); //OK
    app.all('/api/user/logout', routeApiUsers.logout ); //OK
    app.post('/api/user/reset', routeApiUsers.reset ); //OK
    app.post('/api/user/reset/do', routeApiUsers.doReset ); //OK
    app.post('/api/user/verify', routeApiUsers.verify );
    app.post('/api/user/verify/do', routeApiUsers.doVerify );
    app.post('/api/user/delete', routeApiUsers.delete );
    /*
    app.post('/api/user/update/name', routeApiUsers.load ); 
    app.post('/api/user/update/mail', routeApiUsers.load ); 
    app.post('/api/user/update/password', routeApiUsers.load ); 
    app.post('/api/user/update/language', routeApiUsers.load );     
    */
    app.post('/api/user/check/name', routeApiUsers.checkUsernameAvailable); //OK
    app.post('/api/user/check/mail', routeApiUsers.checkEmailAvailable); //OK
    
    
    // TODO ####################################################################################
    
    //app.post('/api/post', routeMain.requireLogin, routeApiPosts.create );
    app.post('/api/post', routeApiPosts.create );
    app.put('/api/post/:pid', routeApiPosts.update );
    app.get('/api/post/:pid', routeApiPosts.get );
    app.delete('/api/post/:pid', routeApiPosts.delete );
    app.post('/api/post/:pid/donate', routeApiPosts.donate );
    app.post('/api/post/:pid/share', routeApiPosts.share );
    app.get('/api/post/:pid/upvote', routeApiPosts.upvote );
    app.get('/api/post/:pid/downvote', routeApiPosts.downvote );
    app.get('/api/post/:pid/unvote', routeApiPosts.unvote );
    app.delete('/api/post/:pid/upvote', routeApiPosts.unvote );
    app.delete('/api/post/:pid/downvote', routeApiPosts.unvote );    
    app.get('/api/post/:pid/comments', routeApiPosts.comments );
    app.post('/api/post/search', routeApiPosts.search );
    
    
    
    //app.get('/api/comment/:cid', routeMain.requireLogin, routeApiComments.get );
    
    
    app.post('/api/comment', routeApiComments.create );
    app.put('/api/comment/:cid', routeApiComments.update );
    app.get('/api/comment/:cid', routeApiComments.get );
    app.delete('/api/comment/:cid', routeApiComments.delete );
    app.post('/api/comment/:cid/share', routeApiComments.share );
    app.post('/api/comment/:cid/upvote', routeApiComments.upvote );
    app.post('/api/comment/:cid/downvote', routeApiComments.downvote );
    
    app.post('/api/file', routeApiFiles.create );
    app.put('/api/file/:fid', routeApiFiles.update );
    app.get('/api/file/:fid', routeApiFiles.get );
    app.get('/api/file/:fid/meta', routeApiFiles.getMeta );
    app.delete('/api/file/:fid', routeApiFiles.delete );
    
    
    app.post('/api/message', routeApiMessages.create );
    app.put('/api/message/:mid', routeApiMessages.update );
    app.get('/api/message/:mid', routeApiMessages.get );
    app.delete('/api/message/:mid', routeApiMessages.delete );    

    app.post('/api/vote', routeApiVotes.create );
    app.put('/api/vote/:vid', routeApiVotes.update );
    app.get('/api/vote/:vid', routeApiVotes.get );
    app.delete('/api/vote/:vid', routeApiVotes.delete );