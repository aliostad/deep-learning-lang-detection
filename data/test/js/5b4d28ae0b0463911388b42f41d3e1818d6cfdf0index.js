'use strict';

var express = require('express');

var notesController = require('../controllers/notesController.js');
var eventsController = require('../controllers/eventsController.js');
var authorsController = require('../controllers/authorsController.js');
var subjectsController = require('../controllers/subjectsController.js');
var communitiesController = require('../controllers/communitiesController.js');
var notebookController = require('../controllers/notebookController.js');

var router = express.Router();

router.post('/notes',notesController.createNote);
router.get('/notes',notesController.showNotesByQuery);
// router.get('/notes',notesController.indexNotes);
// router.delete('/notes',notesController.destroy);
router.delete('/notes',notesController.deleteNote);
router.delete('/notes/all',notesController.destroy);

router.post('/authors',authorsController.createUser);
router.get('/authors',authorsController.indexUsers);
router.get('/authors/:author',notesController.showNotesByAuthor);

router.get('/notes/subjects/:subject',notesController.showNotesBySubject);
router.get('/notes/subjects',subjectsController.showSubjects);

router.get('/communities',communitiesController.indexCommunities);
router.post('/communities',communitiesController.createCommunity);
router.delete('/communities',communitiesController.destroy);

router.get('/events',eventsController.indexEvents);
router.post('/events',eventsController.createEvent);
router.delete('/events',eventsController.destroy);

router.post('/likes',notesController.likeNote);
router.get('/likes',notesController.indexLikes);
router.delete('/likes',notesController.deleteLikes);
router.post('/views',notesController.viewNote);
router.get('/views',notesController.indexViews);
router.delete('/views',notesController.deleteViews);

router.post('/notebooks',notebookController.createNotebook);
router.get('/notebooks',notebookController.indexNotebooks);
router.put('/notebooks',notebookController.addNote);
router.delete('/notebooks',notebookController.destroy);
module.exports = router;
