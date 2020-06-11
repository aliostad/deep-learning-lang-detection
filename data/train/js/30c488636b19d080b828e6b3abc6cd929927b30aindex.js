'use strict';

import angular from 'angular';

import CacheService from './cache.service';
import DataService from './data.service';
import SocketService from './socket.service';
import ToastService from './toast.service';
import FileService from './file.service';

const services = angular.module('app.services', []);

services
    .service('CacheService', CacheService)
    .service('DataService', DataService)
    .service('SocketService', SocketService)
    .service('ToastService', ToastService)
    .service('FileService', FileService);

export default services.name;
