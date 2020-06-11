'use strict';

const angular = require('angular');

exports = angular.module('topics', [])
            .controller('TopicsCtrl', require('./topics-controller'))
            .controller('TopicSubmitCtrl', require('./topic-submit-controller'))
            .controller('TopicCtrl', require('./topic-controller')) // Singular
            .controller('ActionCtrl', require('./action-controller'))
            .controller('ActionsCtrl', require('./actions-controller'))
            .service('AddressService', require('./address-service'))
            .service('ActionService', require('./action-service'))
            .service('TopicService', require('./topics-service'))
            .service('LinkFactory', require('./link-factory'))
            .service('LinkService', require('./link-service'));
