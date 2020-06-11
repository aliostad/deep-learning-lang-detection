import API from '../../middleware/api'
import loadError from '../load/error'
import loadSuccess from '../load/success'
import loading from '../loading'
import signIn from './sign-in'

export const USER_SIGNED_UP = 'USER_SIGNED_UP'

const api = new API()
const users = api.service('users')

export default (user) => {
  return (dispatch) => {
    dispatch(loading(true))

    users.create(user)
    .then((response) => {
      dispatch(loadSuccess())
      dispatch({ type: USER_SIGNED_UP })
      dispatch(signIn(user))
    })
    .catch((error) => {
      dispatch(loadError(error))
    })
    .then(() => {
      dispatch(loading(false))
    })
  }
}
