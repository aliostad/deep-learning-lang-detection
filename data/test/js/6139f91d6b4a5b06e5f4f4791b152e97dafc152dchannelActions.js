export const CREATE_MESSAGE = 'CREATE_MESSAGE';
export const CHANGE_USERNAME = 'CHANGE_USERNAME';
export const SUBMIT_MESSAGE = 'SUBMIT_MESSAGE';

export function createMessage(message) {
  return {
    type: CREATE_MESSAGE,
    message: message
  };
}

export function changeUsername(user) {
  return {
    type: CHANGE_USERNAME,
    user: user
  };
}

export function submitMessage(message, chan) {
  chan.push('new:msg', message)
  return {
    type: SUBMIT_MESSAGE,
    sendingData: true,
    message: message
  };
}
