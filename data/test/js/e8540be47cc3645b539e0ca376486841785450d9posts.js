/**
 * Created by pasquale on 26/08/2017.
 */

import * as Api from '../utils/Api'
import {loadingPostsError, loadingPosts} from './loading'
import * as constants from '../actions/constants'


export function posts(posts) {
    return {
        type: constants.GET_ALL_POSTS,
        posts,
    }
}

export function post(post) {
    return {
        type: constants.GET_POST,
        post,
    }
}

export function voteP(vote, id) {
    return {
        type: constants.VOTE_POST,
        vote: vote,
        id: id,
    }
}

export function deleteP(id) {
    return {
        type: constants.DELETE_POST,
        id,
    }
}

export function fetchAllPosts() {
    return function (dispatch) {
        dispatch(loadingPosts(true))
        return Api.getPosts().then(
            data => {
                dispatch(loadingPosts(false))
                return dispatch(posts(data))
            },
            error => {
                dispatch(loadingPosts(false))
                dispatch(loadingPostsError())
            }
        )
    }
}

export function fetchPost(id) {
    return function (dispatch) {
        dispatch(loadingPosts(true))
        return Api.getPost(id).then(
            data => {
                dispatch(loadingPosts(false))
                return dispatch(post(data))
            },
            error => {
                dispatch(loadingPosts(false))
                dispatch(loadingPostsError())
            }
        )
    }
}

export function votePost(vote, id) {
    return function (dispatch) {
        return Api.votePost(vote, id).then(
                dispatch(voteP(vote, id))
        )
    }
}

export function editPost(data, id) {
    return function (dispatch) {
        return Api.editPost(data, id).then(dispatch(fetchPost(id)))
    }
}

export function deletePost(id) {
    return function (dispatch) {
        return Api.deletePost(id).then(dispatch(deleteP(id)))
    }
}

export function addNewPost(data) {
    return function (dispatch) {
        return Api.addPost(data).then(dispatch(fetchAllPosts()))
    }
}
