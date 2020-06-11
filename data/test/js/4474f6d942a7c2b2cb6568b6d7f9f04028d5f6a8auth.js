export const refreshLogin = (user = null) => {
  return (dispatch) => {
    if (user) {
      dispatch(setUser(user))
    } else {
      $.ajax({
        url: '/api/auth/user',
        type: 'GET',
        dataType: 'JSON'
      }).done( user => {
        dispatch(setUser(user));
      }).fail( err => {
      });
    }
  }
}

export const logout = (router) => {
  return (dispatch) => {
    $.ajax({
      url: '/api/auth/sign_out',
      type: 'DELETE'
    }).done( () => {
      router.push('/signin')
      dispatch(setUser())
    })
  }
}

const setUser = (user = {}) => {
  return { type: 'USER', ...user }
}


