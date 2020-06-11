'use strict';

import {Config} from './config/config';
import {AppController} from './app.controller';
import {LoginController} from './login/login.controller';
import {YouController} from './you/you.controller';
import {SettingsController} from './settings/settings.controller';
import {FriendsController} from './friends/friends.controller';

var app = angular.module('app', ['ngMaterial', 'ngRoute']);

app.config(Config);
app.controller('AppController', [AppController]);
app.controller('LoginController', [LoginController]);
app.controller('YouController', [YouController]);
app.controller('SettingsController', ['$timeout', SettingsController]);
app.controller('FriendsController', ['$timeout', FriendsController]);
