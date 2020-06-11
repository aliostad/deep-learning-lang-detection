import { createStore } from '@/store';
import ACTIONS from '@/store/ACTIONS';

describe('store/actions/moveTarget', () => {
  it('replaces a line when the dot tool is enabled and selected', () => {
    const store = createStore();
    store.dispatch(ACTIONS.SET_INITIAL_BITMAP, [[0, 0, 0], [0, 0, 0], [0, 0, 0]]);
    store.dispatch(ACTIONS.SET_PALETTE_COLORS, ['white', 'black']);
    store.dispatch(ACTIONS.SET_PALETTE_INDEX, 1);

    store.dispatch(ACTIONS.MOVE_TARGET, { x: 0, y: 0 });
    store.dispatch(ACTIONS.TOGGLE_TOOL, 'dot-tool');
    store.dispatch(ACTIONS.ENABLE_TOOL);
    store.dispatch(ACTIONS.MOVE_TARGET, { x: 2, y: 2 });

    expect(store.getters.pixels).to.eql([
      ['black', 'white', 'white'],
      ['white', 'black', 'white'],
      ['white', 'white', 'black'],
    ]);
  });

  it('replaces fill when the fill tool is enabled and selected', () => {
    const store = createStore();
    store.dispatch(ACTIONS.SET_INITIAL_BITMAP, [[0, 0, 1], [0, 1, 0], [1, 0, 0]]);
    store.dispatch(ACTIONS.SET_PALETTE_COLORS, ['white', 'black']);
    store.dispatch(ACTIONS.SET_PALETTE_INDEX, 1);

    store.dispatch(ACTIONS.MOVE_TARGET, { x: 0, y: 0 });
    store.dispatch(ACTIONS.TOGGLE_TOOL, 'fill-tool');
    store.dispatch(ACTIONS.ENABLE_TOOL);
    store.dispatch(ACTIONS.MOVE_TARGET, { x: 2, y: 2 });

    expect(store.getters.pixels).to.eql([
      ['black', 'black', 'black'],
      ['black', 'black', 'black'],
      ['black', 'black', 'black'],
    ]);
  });
});
