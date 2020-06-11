import API from '../../api'
import { loading, loadError, loadSuccess, authError } from '../loading'

export const CREATE_BATCH ='CREATE_BATCH'

const api = new API()

export default (newBatch) => {
  return (dispatch) => {
    dispatch(loading(true))

    api.app.authenticate()
      .then(() => {
        api.service('batches')
          .create(newBatch)
          .then((result) => {
            dispatch(loadSuccess())
            dispatch(loading(false))
          })
          .catch((error) => {
            dispatch(loading(false))
            dispatch(loadError(error))
          })
      })
      .catch(() => {
        dispatch(loading(false))
        dispatch(authError())
      })
  }
}
