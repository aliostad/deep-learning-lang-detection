import {
  CONNECT_CHANNEL,
  ADD_MESSAGE,
  RECEIVE_MESSAGE,
  CREATE_CHANNEL
} from '../constants/action_types';

import client from '../libs/client';
import Message from '../models/message';

export function initialize(channel, user) {
  return (dispatch, getState) => {

    client.on('connect', function () {
      const {chat:{channel}} = getState();
      client.subscribe(channel.id);
    });

    client.on('message', function (topic, _message) {
      let message = Message.deserialize(_message);
      dispatch(receiveMessage(message));
    });

    dispatch(createChannel(channel, user));
  };
}

export function createChannel(channel, user) {
  return {
    type: CREATE_CHANNEL,
    channel: channel,
    user: user
  };
}

export function addMessage(message) {
  return {
    type: ADD_MESSAGE,
    message: message
  };
}

export function receiveMessage(message) {
  return {
    type: RECEIVE_MESSAGE,
    message: message
  };
}
