export default {
  transferOwnership: (tile) => {
    console.log('Running transferOwnership... tile parameter is:', tile);

    return function(dispatch) {
      console.log('Running callback function(dispatch) within transferOwnership...');

      dispatch({
        type: 'CHANGE_TILE',
        payload: tile
      })
    }
  },
  loadNewOwner: (country) => {
    console.log('Running loadNewOwner... country parameter is:', country);
    return function(dispatch) {
      dispatch({
        type: 'LOAD_NEW_OWNER',
        payload: {newOwner: country}
      })
    }
  }
}
