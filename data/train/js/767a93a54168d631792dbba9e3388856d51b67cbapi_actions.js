var Dispatcher = require('../dispatcher/dispatcher.js');
var DispatchConstants = require('../constants/dispatch_constants.js');

var ApiActions = {

  loginAttempt: function(data){
    if(data.hasOwnProperty("error")){
      Dispatcher.dispatch({
        actionType: DispatchConstants.LOGIN_FAILURE,
        error: data.error
      });

    } else {
      Dispatcher.dispatch({
        actionType: DispatchConstants.LOGIN_SUCCESS,
        user: data
      });

    }
  },

  registerAttempt: function(data){
    if(data.hasOwnProperty("error")){
      Dispatcher.dispatch({
        actionType: DispatchConstants.REGISTRATION_FAILURE,
        error: data.error
      });

    } else {
      Dispatcher.dispatch({
        actionType: DispatchConstants.REGISTRATION_SUCCESS,
        user: data
      });

    }
  },

  checkSession: function(data){
    if(data.hasOwnProperty("status")){
      Dispatcher.dispatch({
        actionType: DispatchConstants.LOGGED_OUT,
        error: data.error
      });

    } else {
      Dispatcher.dispatch({
        actionType: DispatchConstants.LOGGED_IN,
        user: data
      });
    }
  },

  uploadSuccess: function(data){
    Dispatcher.dispatch({
      actionType: DispatchConstants.UPLOAD_SUCCESS,
      track: data
    }); 
  },

  uploadFailure: function(data){
    Dispatcher.dispatch({
      actionType: DispatchConstants.UPLOAD_FAILURE,
      errors: data.errors
    }); 
  },

  imageUploadSuccess: function(data){
    Dispatcher.dispatch({
      actionType: DispatchConstants.IMAGE_UPLOAD_SUCCESS,
      image: data
    }); 
  },

  imageUploadFailure: function(data){
    Dispatcher.dispatch({
      actionType: DispatchConstants.IMAGE_UPLOAD_FAILURE,
      errors: data.errors
    }); 
  },

  fetchTracks: function(data){
    Dispatcher.dispatch({
      actionType: DispatchConstants.FETCH_TRACKS,
      tracks: data
    }); 
  },

  fetchMyTracks: function(data){
    Dispatcher.dispatch({
      actionType: DispatchConstants.FETCH_MY_TRACKS,
      tracks: data
    }); 
  },

  fetchMyImage: function(data){
    Dispatcher.dispatch({
      actionType: DispatchConstants.FETCH_IMAGE,
      image: data
    }); 
  },

  getUserInfo: function(data){
    Dispatcher.dispatch({
      actionType: DispatchConstants.GET_USER_INFO,
      user: data
    }); 
  },

  startPlayback: function(data){
    Dispatcher.dispatch({
      actionType: DispatchConstants.START_PLAYBACK,
      track: data
    }); 
  },

  pausePlayback: function(data){
    Dispatcher.dispatch({
      actionType: DispatchConstants.PAUSE_PLAYBACK,
      track: data
    }); 
  },

  stopPlayback: function(){
    Dispatcher.dispatch({
      actionType: DispatchConstants.STOP_PLAYBACK,
    }); 
  },

  fetchComments: function(data){
    Dispatcher.dispatch({
      actionType: DispatchConstants.FETCH_COMMENTS,
      comments: data
    }); 
  },

  addComment: function(data){
    Dispatcher.dispatch({
      actionType: DispatchConstants.NEW_COMMENT,
      comment: data
    }); 
  },

  failedComment: function(){
    Dispatcher.dispatch({
      actionType: DispatchConstants.FAILED_COMMENT,
    }); 
  }


};

module.exports = ApiActions;
