import Mousetrap from 'mousetrap';

export { Mousetrap };
export const mousetrap = Mousetrap();

export const bindShortcut = (keys, actionCreator, preventDefault) => dispatch =>
  (typeof actionCreator === 'function'
    ? mousetrap.bind(keys, e => (dispatch(actionCreator()), !preventDefault))
    : mousetrap.bind(keys, e => (actionCreator.forEach(actionCreator => dispatch(actionCreator())), !preventDefault)));

export const bindShortcuts = (...shortcuts) => dispatch => shortcuts.forEach(shortcut => bindShortcut(...shortcut)(dispatch));
