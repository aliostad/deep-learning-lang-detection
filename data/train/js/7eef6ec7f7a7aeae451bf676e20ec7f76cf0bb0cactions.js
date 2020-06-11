const LOGIN = {
  type : 'LOGIN',
  account : {
    id : 'test',
    name : 'Tester'
  }
};

const TRY_LOGIN = {
  type : 'TRY_LOGIN',
  accountId : 'test'
};

const LOGOUT = {
  type : 'LOGOUT',
  accountId : 'test'
};

function setHeroes() {
  return {
    type : 'SET_HEROES',
    availablePoints : 1,
    heroes : {}
  };
}

export function login(dispatch) {
  dispatch(TRY_LOGIN);
  setTimeout(() => {
    dispatch(LOGIN);
    dispatch(setHeroes());
  }, 200);
}

export function logout() {
  return (dispatch) => {
    dispatch(LOGOUT);
  };
}
