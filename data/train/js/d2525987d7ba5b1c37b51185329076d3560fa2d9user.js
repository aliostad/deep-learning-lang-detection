import { stringify as qs } from 'qs'
import { browserHistory } from 'react-router'

import axios from 'utils/axios'
import { UserTypes } from '../user'
import { ProjectTypes } from '../project'

export const login = (email, password) => (dispatch, getState) => {
  dispatch({ type: UserTypes.LOGIN })
  return axios.post('api/login', qs({ email, password }))
    .then(({ data: { data } }) => {
      dispatch({
        type: UserTypes.LOGIN_SUCCESS,
        user: data
      })
    })
    .catch(({ response: { data } }) => {
      dispatch({
        type: UserTypes.LOGIN_ERROR,
        error: data
      })
    })
}

export const signout = () => (dispatch, getState) => {
  dispatch({ type: UserTypes.SIGNOUT })
  return axios.post('api/logout', {})
    .then(() => {
      dispatch({ type: ProjectTypes.PROJECT_RESET })
      browserHistory.push('/')
      dispatch({
        type: UserTypes.SIGNOUT_SUCCESS
      })
    })
    .catch((error) => {
      dispatch({
        type: UserTypes.SIGNOUT_ERROR,
        error: data
      })
    })
}
