import participantService from './participant.service';
import groupService from './group.service';
import createGroupService from './createGroup.service';
import groupDetailService from './groupDetail.service';
import CONSTANTS from 'crds-constants';

export default angular.
  module(CONSTANTS.MODULES.GROUP_TOOL).
  service('ParticipantService', participantService).
  service('GroupService', groupService).
  service('CreateGroupService', createGroupService).
  service('GroupDetailService', groupDetailService);
