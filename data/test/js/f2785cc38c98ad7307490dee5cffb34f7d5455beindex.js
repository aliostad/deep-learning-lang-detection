import angular from 'angular';
import UserService from './user.service'
import JwtService from './jwt.service'
import ProfileService from './profile.service'
import ArticlesService from './articles.service'
import CommentsService from './comments.service'

// Create the module where our functionality can attach to
let servicesModule = angular.module('app.services', []);

servicesModule.service('User', UserService);
servicesModule.service('JWT', JwtService);
servicesModule.service('Profile', ProfileService);
servicesModule.service('Articles', ArticlesService);
servicesModule.service('Comments', CommentsService);

export default servicesModule;
