import { cycleFlash } from '../src/actions';
import middleware from '../src/middleware';

const mockDispatch = jest.fn();
const TRIGGER = 'FOO';

const fakeStore = () => ({
  dispatch: mockDispatch,
});

const dispatchWithFakeStore = (mw, action) => {
  let dispatched = null;
  const dispatch = mw(fakeStore())(
    actionAttempt => (dispatched = actionAttempt),
  );
  dispatch(action);
  return dispatched;
};

afterEach(() => {
  jest.clearAllMocks();
});

it('should dispatch cycleFlash on TRIGGER actions', () => {
  const mw = middleware({ cycle: TRIGGER });

  const action = {
    type: TRIGGER,
  };

  dispatchWithFakeStore(mw, action);

  expect(mockDispatch).toHaveBeenCalledWith(cycleFlash());
});

it('should not dispatch cycleFlash on other actions', () => {
  const mw = middleware({ cycle: TRIGGER });

  const action = {
    type: 'BAR',
  };

  dispatchWithFakeStore(mw, action);

  expect(mockDispatch).not.toHaveBeenCalledWith();
});

it('should not dispatch cycleFlash if no config is provided', () => {
  const mw = middleware();

  const action = {
    type: TRIGGER,
  };

  dispatchWithFakeStore(mw, action);

  expect(mockDispatch).not.toHaveBeenCalled();
});
