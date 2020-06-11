<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

// API URL
// All
$route['api/person']  = 'person/api/person_controller/person';
$route['api/person/id/(:num)']  = 'person/api/person_controller/person';
// Work experience
$route['api/workexperience']  = 'person/api/workexperience_controller/work';
$route['api/workexperience/id/(:num)']  = 'person/api/workexperience_controller/work';
$route['api/person/id/(:num)/workexperiences']  = 'person/api/person_controller/work';
// References
$route['api/reference']  = 'person/api/references_controller/reference';
$route['api/reference/id/(:num)']  = 'person/api/references_controller/reference';
$route['api/person/id/(:num)/references']  = 'person/api/person_controller/references';
// Affiliation
$route['api/affiliation']  = 'person/api/affiliations_controller/affiliation';
$route['api/affiliation/id/(:num)']  = 'person/api/affiliations_controller/affiliation';
$route['api/person/id/(:num)/affiliations']  = 'person/api/person_controller/affiliations';
// Skills
$route['api/skill']  = 'person/api/skills_controller/skill';
$route['api/skill/id/(:num)']  = 'person/api/skills_controller/skill';
$route['api/person/id/(:num)/skills']  = 'person/api/person_controller/skills';
// Trainings
$route['api/training']  = 'person/api/training_controller/training';
$route['api/training/id/(:num)']  = 'person/api/training_controller/training';
$route['api/person/id/(:num)/trainings']  = 'person/api/person_controller/trainings';
// Test Profile
$route['api/test']  = 'person/api/test_controller/test';
$route['api/test/id/(:num)']  = 'person/api/test_controller/test';
$route['api/person/id/(:num)/tests']  = 'person/api/person_controller/tests';
// Details
$route['api/person/id/(:num)/detail']  = 'person/api/person_controller/detail';
$route['api/persondetail/id/(:num)']  = 'person/api/details_controller/detail';
// Education
$route['api/education']  = 'person/api/education_controller/education';
$route['api/education/id/(:num)']  = 'person/api/education_controller/education';
$route['api/person/id/(:num)/education']  = 'person/api/person_controller/education';
// Government ID
$route['api/person/id/(:num)/idnos']  = 'person/api/person_controller/idnos';
// Addresses
$route['api/person/id/(:num)/addresses']  = 'person/api/person_controller/addresses';
// Accountabilities
$route['api/person/id/(:num)/accountabilities']  = 'person/api/person_controller/accountabilities';
// Family
$route['api/family']  = 'person/api/family_controller/family';
$route['api/family/id/(:num)']  = 'person/api/family_controller/family';
$route['api/person/id/(:num)/family']  = 'person/api/person_controller/family';