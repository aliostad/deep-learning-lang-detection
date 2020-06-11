export const addBlockAction = ({dispatch}, payload, done) => {
  dispatch('ADD_BLOCK', payload);
  done();
};

export const setFocusAction = ({dispatch}, payload, done) => {
  dispatch('SET_FOCUS', payload);
  done();
};

export const setContentAction = ({dispatch}, payload, done) => {
  dispatch('SET_CONTENT', payload);
  done();
};

export const changeBlockAction = ({dispatch}, payload, done) => {
  dispatch('CHANGE_BLOCK', payload);
  done();
};

export const deleteBlockAction = ({dispatch}, payload, done) => {
  dispatch('DELETE_BLOCK', payload);
  done();
};
