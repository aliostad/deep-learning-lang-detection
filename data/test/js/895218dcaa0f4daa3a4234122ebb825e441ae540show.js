"use strict";

var Nuclear = require("nuclear-js");
var actionTypes = require("../action-types");

function setShow(_, data) {
  return Nuclear.toImmutable(data).withMutations(show => {
    return show
      .set("Released", new Date(show.get("Released")))
      .set("DateCreated", new Date(show.get("DateCreated")));
  });
}

function resetShow() {
  return Nuclear.toImmutable({});
}

module.exports = new Nuclear.Store({

  getInitialState() {
    return resetShow(null);
  },

  initialize() {
    this.on(actionTypes.SetShow, setShow);
    this.on(actionTypes.ResetShow, resetShow);
  },

});
