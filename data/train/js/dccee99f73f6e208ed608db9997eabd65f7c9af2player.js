import React from 'react';
import Redux from 'redux';
import {START_PLAYING, STOP_PLAYING, SET_CURRENT_SONG, SET_LIST} from '../constants';
import axios from 'axios';
import {skip} from '../utils';
import AUDIO from '../audio'


export const startPlaying = () => {
  return {
    type: START_PLAYING,
  }
};

export const play = () => {
  return dispatch => {
    AUDIO.play();
    dispatch(startPlaying());
  }
}

export const stopPlaying = () =>{
  return {
    type: STOP_PLAYING,
  }
}

export const pause = () => {
  return dispatch => {
    AUDIO.pause();
    dispatch(stopPlaying())
  }
}

export const setCurrentSong = (currentSong) => {
  return {
    type: SET_CURRENT_SONG,
    currentSong: currentSong,
  }
}

export const setCurrentSongList = (currentSongList) => {
  return {
    type: SET_LIST,
    currentSongList: currentSongList
  }
}

export const load = (currentSong, currentSongList) => {
  return dispatch => {
    AUDIO.src = currentSong.audioUrl;
    AUDIO.load();
    dispatch(setCurrentSong(currentSong));
    dispatch(setCurrentSongList(currentSongList));
  }
}

export const startSong = (song, list)=>{
  return dispatch => {
    dispatch(pause());
    dispatch(load(song, list));
    dispatch(play());
  }
}

export const toggle = () => (dispatch, getState) => {
  const { isPlaying } = getState().player;
  if (isPlaying) dispatch(pause());
  else dispatch(play());
};

export const toggleOne = (selectedSong, selectedSongList) =>
  (dispatch, getState) => {
    const { currentSong } = getState().player;
    if (selectedSong.id !== currentSong.id)
      dispatch(startSong(selectedSong, selectedSongList));
    else dispatch(toggle());
};

export const next = () =>
  (dispatch, getState) => {
    dispatch(startSong(...skip(1, getState().player)));
};

export const prev = () =>
  (dispatch, getState) => {
    dispatch(startSong(...skip(-1, getState().player)));
};


/* BUT WAIT THERE'S MORE! (may be helpful later on!) */

const fetchAlbumsFromServer =() => {
  return dispatch => {
    axios.get('/api/albums')
      .then(res => res.data)
      // use the dispatch method the thunkMiddleware gave us
      .then(albums => dispatch(receiveAlbumsFromServer(albums)));
  }
}

export const playSong = songId => {
  return dispatch => {
    // side effects, like using the audio element belong in async action creators too, even if they aren't "async"
    audio.play()
    dispatch(selectSong(songId));
  }
}
