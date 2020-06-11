'use strict';

import biff from '../dispatcher/dispatcher';

const TimerActions = biff.createActions({
  startInspection(data) {
    this.dispatch({
      actionType: 'START_INSPECTION',
      data: data
    });
  },
  newSolve() {
    this.dispatch({
      actionType: 'NEW_SOLVE'
    });
  },
  startSolve(data) {
    this.dispatch({
      actionType: 'START_SOLVE',
      data: data
    });
  },
  endSolve(data) {
    this.dispatch({
      actionType: 'END_SOLVE',
      data: data
    });
  },
  tick() {
    this.dispatch({
      actionType: 'TICK'
    });
  }
});

export default TimerActions;
