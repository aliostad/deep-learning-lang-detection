var express = require('express');
var router = express.Router();

var api_blog = require('./blog/api_blog');
var api_community = require('./community/api_community');
var api_course = require('./course/api_course');
var api_hackathon = require('./hackathon/api_hackathon');
var api_hackcampus = require('./hackcampus/api_hackcampus');
var api_home = require('./home/api_home');
var api_aboutus = require('./aboutus/aboutus');

router.use('/home', api_home);
router.use('/blog', api_blog);
router.use('/community', api_community);
router.use('/course', api_course);
router.use('/hackathon', api_hackathon);
router.use('/hackcampus', api_hackcampus);
router.use('/aboutus',api_aboutus);

module.exports = router;