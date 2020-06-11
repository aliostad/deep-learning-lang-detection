import * as ReadableAPI from '../utils/api'

export const IS_LOADING = "IS_LOADING"
export const isLoading = (bool) => (
   {
    type: IS_LOADING,
    isLoading: bool
  }
)

export const SERVER_ERROR = "SERVER_ERROR"
export const serverError = (bool) => (
   {
    type: SERVER_ERROR,
    serverError: bool
  }
)


export const ADD_POST = "ADD_POST"
export function addPost(title, body, owner, category) {

  return function (dispatch) {

    dispatch(isLoading(true))

    return ReadableAPI.addPost(title, body, owner, category)
      .then(
        response => response.json(),
        error => dispatch(serverError())
      )
      .then((data) => {
        dispatch(isLoading(false))
        dispatch(
          {
            type:ADD_POST,
            data

          }

        )
      }
      )
  }
}




export const DELETE_POST = "DELETE_POST"
export function deletePost(postId) {

  return function (dispatch) {

    dispatch(isLoading(true))

    return ReadableAPI.deletePost(postId)
      .then(
        response => response.json(),
        error => dispatch(serverError())
      )
      .then(() => {
        dispatch(isLoading(false))
        dispatch(
          {
            type: DELETE_POST,
            postId: postId
          }

        )}
      )
  }
}


export const UPDATE_POST = "UPDATE_POST"
export function updatePost(postId, title, body) {

  return function (dispatch) {

    dispatch(isLoading(true))

    return ReadableAPI.editPost(postId, title, body)
      .then(
        response => response.json(),
        error => dispatch(serverError())
      )
      .then(() =>{
        dispatch(isLoading(false))
        dispatch(
          {
            type: UPDATE_POST,
            postId,
            title,
            body
          }

        )}
      )
  }
}

export const FETCH_POSTS = "FETCH_POSTS"
export function fetchPosts() {

  return function (dispatch) {

    dispatch(isLoading(true))

    return ReadableAPI.getPosts()
      .then(
        response => response.json(),
        error => dispatch(serverError())
      )
      .then((data) =>{
        dispatch(isLoading(false))
        dispatch(
          {
            type: FETCH_POSTS,
            data
          }

        )}
      )
  }
}


export const READ_POST = "READ_POST"
export function readPost(postId) {

  return function (dispatch) {

    dispatch(isLoading(true))

    return ReadableAPI.getPostById(postId)
      .then(
        response => response.json(),
        error => dispatch(serverError())
      )
      .then((data) => {
        dispatch(isLoading(false))
        dispatch(
          {
            type: READ_POST,
            data
          }

        )}
      )
  }
}

export const UPVOTE_POST = "UPVOTE_POST"
export function upVotePost(postId) {

  return function (dispatch) {

    dispatch(isLoading(true))

    return ReadableAPI.votePost(postId, "upVote")
      .then(
        response => response.json(),
        error => dispatch(serverError())
      )
      .then(() => {
        dispatch(isLoading(false))
        dispatch(
          {
            type: UPVOTE_POST,
            postId: postId
          }

        )}
      )
  }
}


export const DOWNVOTE_POST = "DOWNVOTE_POST"
export function downVotePost(postId) {

  return function (dispatch) {

    dispatch(isLoading(true))

    return ReadableAPI.votePost(postId, "downVote")
      .then(
        response => response.json(),
        error => dispatch(serverError())
      )
      .then(() =>{
        dispatch(isLoading(false))
        dispatch(
          {
            type: DOWNVOTE_POST,
            postId: postId
          }

        )}
      )
  }
}
