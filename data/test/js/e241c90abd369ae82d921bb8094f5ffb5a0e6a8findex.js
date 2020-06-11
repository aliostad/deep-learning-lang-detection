import * as actionTypes from 'constants/actionTypes'
import * as kisi from 'utils/kisiApi'

export const loadLocks = () => async dispatch => {
  dispatch({type: actionTypes.LOCKS_REQUEST})
  try {
    const locks = await kisi.getLocks()
    dispatch({type: actionTypes.LOCKS_RECEIVE, locks})
  } catch (error) {
    dispatch({type: actionTypes.LOCKS_ERROR, error})
  }
}

export const unlock = lockId => async dispatch => {
  dispatch({type: actionTypes.UNLOCK_REQUEST, lockId})
  try {
    await kisi.unlock(lockId)
    dispatch({type: actionTypes.UNLOCK_SUCCESS, lockId})
  } catch (error) {
    dispatch({type: actionTypes.UNLOCK_ERROR, error, lockId})
  }
  dispatch(resetLock(lockId))
}

const resetLock = lockId => dispatch => {
  setTimeout(
    () => dispatch({type: actionTypes.UNLOCK_RESET, lockId}),
    2000
  )
}
