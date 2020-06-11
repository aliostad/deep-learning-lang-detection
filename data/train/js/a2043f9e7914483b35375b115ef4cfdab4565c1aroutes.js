const express = require('express');

//const authController = require('./controllers/authController');
const friendsController = require('./controllers/friendsController');
const booksController = require('./controllers/booksController');
const postController = require('./controllers/postController');
const commentController = require('./controllers/commentController');


const router = express.Router();

router.get('/friends', friendsController.friends);
router.post('/inviteFriend', friendsController.inviteFriend);
router.get('/inviteFriends', friendsController.inviteFriends);
router.post('/acceptedInviteFriend', friendsController.acceptedInviteFriend);
router.post('/listAcceptedInviteFriends', friendsController.listAcceptedInviteFriends);
router.post('/declinedInviteFriend', friendsController.declinedInviteFriend);
//router.post('/declinedFriend', friendsController.declinedFriend);
//router.post('/friendslist', friendsController.friendslist);
router.get('/getBook', booksController.getBooks);
router.post('/post', postController.post);
router.get('/posts', postController.posts);
router.post('/comment', commentController.post);


// router.post('/register', authController.register);
// router.post('/login', authController.login);
// router.use(authController.authorization);
// router.get('/profile', authController.profile);


module.exports = router;
