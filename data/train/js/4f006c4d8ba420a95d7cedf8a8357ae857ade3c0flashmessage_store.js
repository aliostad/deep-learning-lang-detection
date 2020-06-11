"use strict";

import Reflux from "reflux";
import {FlashMessageActions} from "../actions";

const FlashMessageStore = Reflux.createStore({

  init() {
    this.contextualName = false;
    this.message = "";
  },

  listenables: FlashMessageActions,

  _onMessage(message, contextualName) {
    console.log("message:", message);
    this.trigger({
      contextualName,
      message
    });
  },

  onClear() {
    this.trigger({message: null, contextualName: null});
  },

  onError(message) {
    this._onMessage(message, "error");
  },

  onWarning(message) {
    this._onMessage(message, "warning");
  },

  onInfo(message) {
    this._onMessage(message, "info");
  },

  onSuccess(message) {
    this._onMessage(message, "success");
  }

});

export default FlashMessageStore;