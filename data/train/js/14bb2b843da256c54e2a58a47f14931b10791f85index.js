import {
  SET_ROUTER,
  DELETE_ROUTER,
  SET_REVERSE,
  SET_SCROLL_TOP,
} from '../mutations_type';

/**
 * @param  {Object} router
 */
export const setRouter = ({ dispatch }, router) => dispatch(SET_ROUTER, router);

/**
 * @param  {String} path
 */
export const deleteRouter = ({ dispatch }, path) => dispatch(DELETE_ROUTER, path);

/**
 * @param  {Boolean} reverse
 */
export const setReverse = ({ dispatch }, reverse) => dispatch(SET_REVERSE, reverse);

/**
 * @param  {Object} router
 */
export const setScrollTop = ({ dispatch }, router) => dispatch(SET_SCROLL_TOP, router);
