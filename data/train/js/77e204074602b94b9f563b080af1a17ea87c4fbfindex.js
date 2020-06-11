import angular from 'angular';

//Controllers
import HomeController from './controllers/home.controller';
import AddController from './controllers/add.controller';
import OptionsController from './controllers/options.controller';
import SingleFeatureController from './controllers/singleFeature.controller';

//service
import LocalizeService from './services/localize.service';
import UploadService from './services/upload.service';
import FeaturedService from './services/featured.service';

console.log(FeaturedService);

angular 
  .module('app.layout', ['app.social'])
  .controller('HomeController', HomeController)
  .controller('AddController', AddController)
  .controller('OptionsController', OptionsController)
  .controller('SingleFeatureController', SingleFeatureController)
 
  .service('LocalizeService',LocalizeService)
  .service('UploadService',UploadService)
  .service('FeaturedService', FeaturedService)

;