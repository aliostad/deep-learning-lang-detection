import angular from 'angular';
import AppInitializationController from './AppInitializationController';
import LeagueJoinController from './LeagueJoinController';
import LoginButtonController from './LoginButtonController';
import BlurController from './BlurController';
import WelcomeController from './WelcomeController';

export default angular.module('FantasyBach.controllers', [])
    .controller('AppInitializationController', AppInitializationController)
    .controller('LeagueJoinController', LeagueJoinController)
    .controller('LoginButtonController', LoginButtonController)
    .controller('BlurController', BlurController)
    .controller('WelcomeController', WelcomeController)
    .name;
