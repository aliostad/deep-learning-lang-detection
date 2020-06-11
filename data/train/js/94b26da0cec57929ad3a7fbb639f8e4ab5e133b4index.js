import { v4 as uuid } from 'node-uuid';
import * as MessageTypes from './constants/MessageTypes';

const decorateWorker = worker => {

  const hashMap = new Map();
  worker.addEventListener('message', ({data}) => {
    const promise = hashMap.get(data.messageHash);
    if (promise) {
      if (data.type === MessageTypes.RESPONSE_AS_PROMISED) {
        promise.resolve(data);
      } else if (data.type === MessageTypes.ERROR_AS_PROMISED) {
        promise.error(data);
      } else {
        console.warn(`Unknown message type ${data.type}`, data);
      }
      hashMap.delete(data.messageHash);
    }
  });
  worker.sendMessage = (type, data) => {
    return new Promise((resolve, error) => {
      const messageHash = uuid();
      worker.postMessage({
        type: MessageTypes.MESSAGE_AS_PROMISED,
        messageHash,
        data
      });
      hashMap.set(messageHash, {resolve, error});
    });
  };

  worker.addMessageListener = handler => {
    worker.addEventListener('message', ({data}) => {
      if (data.type === MessageTypes.RESPONSE_AS_PROMISED || data.type === MessageTypes.ERROR_AS_PROMISED) {
        return;
      }
      handler(data);
    });
  };

  return worker;
};

const isMessageAsPromised = message => {
  return message.data.type === MessageTypes.MESSAGE_AS_PROMISED;
};

const getMessage = message => {
  const data = message.data;
  return {
    hash: data.messageHash,
    data: data.data
  };
};

const createMessage = message => {
  return {
    type: MessageTypes.MESSAGE_AS_PROMISED,
    messageHash: message.hash,
    data: message.data
  };
};

const createResponse = message => {
  return {
    type: MessageTypes.RESPONSE_AS_PROMISED,
    messageHash: message.hash,
    data: message.data
  };
};

const createError = message => {
  return {
    type: MessageTypes.ERROR_AS_PROMISED,
    messageHash: message.hash,
    data: message.data
  };
};

export {
  decorateWorker,
  isMessageAsPromised,
  getMessage,
  createMessage,
  createResponse,
  createError
};
