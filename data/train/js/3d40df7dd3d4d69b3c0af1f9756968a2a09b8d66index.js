(function() {
  'use strict';

  var constants = require('crds-constants');

  angular.module(constants.MODULES.GROUP_FINDER)
    .factory('GroupInfo',                   require('./group_info.service'))
    .factory('GroupInvitationService',      require('./group_invitation.service.js'))
    .factory('Results',                     require('./results.service'))
    .factory('Person',                      require('./person.service'))
    .factory('Email',                       require('./email.service'))
    .service('Responses',                   require('./response.service'))
    .service('Address',                     require('./address.service'))
    .service('GroupQuestionService',        require('./group_questions.service'))
    .service('ParticipantQuestionService',  require('./participant_questions.service'))
    .service('GoogleDistanceMatrixService', require('./google_distance_matrix.service').service)
    .run(require('./google_distance_matrix.service').init)
  ;

})();
