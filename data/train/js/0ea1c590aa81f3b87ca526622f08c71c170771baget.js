// src/actions/batches/get.js

import API from '../../api'
import {
  APP_LOADING,
  APP_DONE_LOADING,
  LOAD_ERROR,
  LOAD_SUCCESS
} from '../loading'

export const GOT_BATCH = 'GOT_BATCH'

const api = new API()

export default (batchId) => {
  return (dispatch) => {
    dispatch({ type: APP_LOADING })

    const backend = api.service('batches')

    api.app.authenticate()
      .then(() => {
        backend.get(batchId)
          .then((result) => {
            dispatch({ type: APP_DONE_LOADING })
            dispatch({ type: LOAD_SUCCESS })

            dispatch({
              type: GOT_BATCH,
              payload: result
            })
          })
          .catch((error) => {
            dispatch({ type: APP_DONE_LOADING })
            dispatch({
              type: LOAD_ERROR,
              payload: error.message
            })
          })
      })
      .catch((error) => {
        dispatch({ type: APP_DONE_LOADING })
        dispatch({
          type: LOAD_ERROR,
          payload: error.message
        })
      })
  }
}
