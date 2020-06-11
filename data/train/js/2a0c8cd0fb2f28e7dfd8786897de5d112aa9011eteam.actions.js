'use strict';

var AppDispatcher = require('../app-dispatcher'),
    config = require('./team.config'),
    Actions = config.Actions,
    UserActions = require('../../config/config').Actions;

var dispatch = function(eventName, data) {
    AppDispatcher.dispatch({
        eventName: eventName,
        data: data
    });
};

var TeamActions = {
    teamsReceived: function(teams) {
        dispatch(Actions.TEAMS_RECEIVED, teams);
    },
    created: function(team) {
        dispatch(Actions.TEAM_SAVED, team);
    },
    updated: function(team) {
        dispatch(Actions.TEAM_SAVED, team);
    },
    deleted: function(team) {
        dispatch(Actions.TEAM_REMOVED, team);
    },
    activated: function(user) {
        dispatch(UserActions.USER_SAVED, user);
    },
    invitedUser: function(team) {
        dispatch(Actions.TEAM_SAVED, team);
    },
    removedUser: function(team) {
        dispatch(Actions.TEAM_SAVED, team);
    }
};

module.exports = TeamActions;
