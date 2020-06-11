import * as types from './../constants/action_types';

const initialState = {
  loaded: false,
  showMovieInfo: false,
  showFilter: false,
  showPicture: false
};

export default function(state = initialState, action) {

  switch(action.type) {

    case 'IS_LOADED':
      return {
        ...state,
        loaded: !state.loaded
      };

    case 'SELECT_MOVIE':
      return {
        ...state,
        showMovieInfo: !state.showMovieInfo,
        showFilter: false,
        showPicture: false
      };

    case 'SELECT_FILTER':
      return {
        ...state,
        showMovieInfo: false,
        showPicture: false,
        showFilter: false
      };

    case 'EXPAND_FILTERS':
      return {
        ...state,
        showFilter: !state.showFilter
      };

    case 'SELECT_PICTURE':
      return {
        ...state,
        showPicture: !state.showPicture
      };

    default:
      return state;
  }
}
