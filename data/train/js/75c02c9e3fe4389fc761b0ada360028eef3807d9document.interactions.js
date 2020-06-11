'use strict';

var AppDispatcher = require('../app-dispatcher'),
    config = require('./document.config'),
    Interactions = config.Interactions,
    DocumentService = require('./document.service');

var dispatch = function(eventName, data) {
    AppDispatcher.dispatch({
        eventName: eventName,
        data: data
    });
};

var DocumentInteractions = {
    loadAll: function() {
        dispatch(Interactions.LOAD_DOCUMENTS);
        DocumentService.getAll();
    },
    create: function(document) {
        dispatch(Interactions.CREATE_DOCUMENT, document);
        DocumentService.create(document);
    },
    update: function(document) {
        dispatch(Interactions.UPDATE_DOCUMENT, document);
        DocumentService.update(document);
    },
    delete: function(document) {
        dispatch(Interactions.DELETE_DOCUMENT, document);
        DocumentService.delete(document);
    },
    activate: function(document) {
        dispatch(Interactions.ACTIVATE_DOCUMENT, document);
    },
    edit: function(document) {
        dispatch(Interactions.EDIT_DOCUMENT, document);
    },
    quitEditor: function() {
        dispatch(Interactions.QUIT_EDITOR, document);
    }
};

module.exports = DocumentInteractions;
