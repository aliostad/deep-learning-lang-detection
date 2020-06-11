import {Router} from './router';

import HomeController from 'components/home/home-controller';
import ClassController from 'components/class/class-controller';
import ScopeController from 'components/scope/scope-controller';
import ArrowController from 'components/arrow/arrow-controller';
import MapsSetsController from 'components/maps-sets/maps-sets-controller';
import DefaultController from 'components/default/default-controller';
import ObjectLiteralsController from 'components/object-literals/object-literals-controller';
import DestructuringController from 'components/destructuring/destructuring-controller';
import RestController from 'components/rest/rest-controller';
import SpreadController from 'components/spread/spread-controller';
import TemplatesController from 'components/templates/templates-controller';
import MiscController from 'components/misc/misc-controller';
import GeneratorsController from 'components/generators/generators-controller';
import ProxiesController from 'components/proxies/proxies-controller';
import SymbolController from 'components/symbol/symbol-controller';
import PromisesController from 'components/promises/promises-controller';

var app = angular.module('app', ['ui.router']);

app.controller('HomeCtrl', HomeController);
app.controller('ClassCtrl', ClassController);
app.controller('ScopeCtrl', ScopeController);
app.controller('ArrowCtrl', ArrowController);
app.controller('MapsSetsCtrl', MapsSetsController);
app.controller('DefaultCtrl', DefaultController);
app.controller('ObjectLiteralsCtrl', ObjectLiteralsController);
app.controller('DestructuringCtrl', DestructuringController);
app.controller('SpreadCtrl', SpreadController);
app.controller('RestCtrl', RestController);
app.controller('TemplatesCtrl', TemplatesController);
app.controller('MiscCtrl', MiscController);
app.controller('GeneratorsCtrl', GeneratorsController);
app.controller('ProxiesCtrl', ProxiesController);
app.controller('SymbolCtrl', SymbolController);
app.controller('PromisesCtrl', PromisesController);

app.config(Router);
