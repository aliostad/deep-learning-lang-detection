module.exports = function(Como) {
    var _ = require('/lib/Underscore/underscore.min'),
        UI = Como.loadUI(),
        $ = require('/lib/Como/Utils'),
        
        showCalendar, showCamera,
        showChat, showGraph, showMap,
        showDirectory, showNote, showUniversity;
        
    showCalendar = function() {
        var Calendar = require('/app/views/Calendar'),
            calendar = new Calendar(Como);
            
        calendar.create().open();
    };
    
    showCamera = function() {
        Ti.API.info('camera');
    };
    
    showChat = function() {
        Ti.API.info('chat');
    };
    
    showDirectory = function() {
        Ti.API.info('directory');
    };
    
    showGraph = function() {
        Ti.API.info('graph');
    };
    
    showMap = function() {
        Ti.API.info('map');
    };
    
    showNote = function() {
        Ti.API.info('note');
    };
    
    showUniversity = function() {
        Ti.API.info('university');
    };
    
    return {
        showCalendar: showCalendar,
        showCamera: showCamera,
        showChat: showChat,
        showDirectory: showDirectory,
        showGraph: showGraph,
        showMap: showMap,
        showNote: showNote,
        showUniversity: showUniversity
    };
};