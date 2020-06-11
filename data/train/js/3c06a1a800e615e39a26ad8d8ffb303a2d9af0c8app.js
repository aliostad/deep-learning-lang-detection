import angular from 'angular';
import 'node_modules/angular-new-router/dist/router.es5';
import { HomeController } from 'home/home';
import { FlugBuchenController } from 'flug-buchen/flug-buchen';
import { PassagierController } from 'passagier/passagier';
import { FlugController } from 'flug/flug';
import { BuchenController } from 'buchen/buchen';
import { PassagierEditController } from 'passagier-edit/passagier-edit';

var app = angular.module('app', ['ngNewRouter']);

class AppController {
 
    constructor($router) {

        $router.config([
            { path: '/',            component: 'home' },
            // index.html#/             HomeController, components/home/home.html, home
            { path: '/flugbuchen',  component: 'flugBuchen' }
        ]);

    }
}

app.controller('AppController', AppController);
app.controller('HomeController', HomeController);
app.controller('FlugBuchenController', FlugBuchenController);
app.controller('PassagierController', PassagierController);
app.controller('FlugController', FlugController);
app.controller('BuchenController', BuchenController);
app.controller('PassagierEditController', PassagierEditController);

app.constant("baseUrl", "http://www.angular.at");

angular.element(document).ready(function() {
  angular.bootstrap(document, ['app']);
});



