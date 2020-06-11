
import angular from 'angular';
import 'angular-ui-router';
import config from './config';
//import 'angular-foundation';

import AddController     from './controllers/add.controller';
import ListController    from './controllers/list.controller'; 
import EditController    from './controllers/edit.controller';
import SingleController  from './controllers/single.controller';
import AboutController   from './controllers/about.controller';
import ContactController from './controllers/contact.controller';
import RecipeService     from './services/recipe.service'; 

angular
  .module('app', ['ui.router'])
  .config(config)
  .controller('ListController',ListController)
  .controller('SingleController', SingleController)
  .controller('ContactController',ContactController)
  .controller('AboutController',AboutController)  
  .controller('AddController', AddController)
  .controller('EditController', EditController)
  .service('RecipeService',RecipeService)
  .constant('PARSE',{
    URL     :'https://api.parse.com/1/',
    CONFIG  :{
      headers :{
        'X-Parse-Application-Id'  :'IpJLIPyvS3MHlgzqP07l31bU3R9jnnY37wul6iAv',
        'X-Parse-REST-API-Key'    :'5aexRwuEb8XhmAwokeHkRhhHW9LtSdu08WNm0BiM'
      }

    }
  })
;