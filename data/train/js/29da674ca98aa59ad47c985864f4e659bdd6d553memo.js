import Http from '../lib/http'
import { showLoader, hideLoader } from './loader'

export const RECIEVE_MEMOLIST = Symbol()
export const DROP_MEMOLIST = Symbol()

export const START_FETCHING_MEMO = Symbol()
export const RECIEVE_MEMO = Symbol()
export const FAIL_TO_FETCH_MEMO = Symbol()
export const ADD_MEMO = Symbol()
export const SET_MEMO = Symbol()
export const DELETE_MEMO = Symbol()


export function dropMemos() {
  return {
    type: DROP_MEMOLIST
  }
}

export function fetchMemos() {
  return (dispatch)=> {
    dispatch(showLoader())
    return Http().get(`/memos`)
    .then(res => {
      dispatch(hideLoader())
      dispatch({
        type: RECIEVE_MEMOLIST,
        items: res.data,
      })
      return res.data
    }, error => {
      dispatch(hideLoader())
    })
  }
}

export function getMemos() {
  return (dispatch, getState)=> {
    let state = getState().memo
    if (state.items.length > 0) {
      return Promise.resolve(state)
    } else {
      return dispatch(fetchMemos())
    }
  }
}


export function fetchMemo(path) {
  return (dispatch)=> {
    dispatch(showLoader())
    const encodedPath = encodeURIComponent(path)
    return Http().get(`/memos/${encodedPath}`)
    .then(res => {
      const memo = res.data
      dispatch(hideLoader())
      dispatch({
        type: RECIEVE_MEMO,
        item: memo,
      })
      return memo
    }, error => {
      dispatch(failToFetchMemo(path))
      dispatch(hideLoader())
    })
  }
}


export function deleteMemo(id) {
  return (dispatch, getState)=> {
    dispatch(showLoader())
    return Http().delete(`/memos/${id}`)
    .then(() => {
      dispatch(dropMemos())
      dispatch(hideLoader())
      dispatch({
        type: DELETE_MEMO,
        id: id,
      })
    }, error => {
      dispatch(hideLoader())
    })
  }
}


function uploadMemo(id, memo) {
  return (dispatch, getState)=> {
    dispatch(showLoader())

    const updating = !!id
    return Http().request({
      method: updating ? 'PATCH' : 'POST',
      url:  updating ? `/memos/${id}` : `/memos`,
      data: memo,
    }).then(res => {
      const memo = res.data
      // dispatch(dropMemos())
      dispatch(hideLoader())
      if (updating) {
        dispatch({
          type: SET_MEMO,
          item: memo,
        })
      } else {
        dispatch({
          type: ADD_MEMO,
          item: memo,
        })
      }
      return memo
    }, error => {
      dispatch(hideLoader())
    })
  }
}


export function createMemo(memo) {
  return uploadMemo(null, memo)
}

export function updateMemo(id, memo) {
  return uploadMemo(id, memo)
}
