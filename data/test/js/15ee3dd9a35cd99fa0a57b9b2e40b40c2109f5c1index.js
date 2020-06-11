const Mission = function () {
  return {
    path: 'scene/mission',
    name: 'scene/mission',
    getComponent(nextState, cb) {
      // if (call && typeof call === 'function') {
      //   call(require('./Mission/model'));
      // }
      require.ensure([], (require) => { cb(null, require('./Mission')); }, 'scenemission');
    },
  };
};

const DispatchPose = function () {
  return {
    path: 'dispatch/dispatchPose',
    name: 'dispatch/dispatchPose',
    getComponent(nextState, cb) {
      require.ensure([], (require) => { cb(null, require('./DispatchPose')); }, 'dispatchPose');
    },
  };
};

//import Mission from './Mission'

export { Mission, DispatchPose };
