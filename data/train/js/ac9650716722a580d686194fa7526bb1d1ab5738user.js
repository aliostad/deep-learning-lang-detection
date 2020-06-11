import {waiting, notWaiting} from './index'
import request from '../utils/tokenApi'
import {error} from './error'

import {GET_PROFILE} from './variables'

export function getProfileById (id) {
  return dispatch => {
    dispatch(waiting())
    request('get', `/getuserprofile/${id}`)
    .then(result => {
      if (result.error) return dispatch(error(result.error))
      dispatch(userProfile(result.body))
      dispatch(notWaiting())
    })
  }
}

export function updateProfile (edited, id) {
  return dispatch => {
    dispatch(waiting())
    request('put', '/myprofile/edit', {user_id: id, updated_profile: edited})
    .then(result => {
      if (result.error) return dispatch(error(result.error))
      dispatch(notWaiting())
    })
  }
}

function userProfile (profile) {
  return {
    type: GET_PROFILE,
    profile
  }
}
