import {
  FETCH_SHOW_DATA,
  FETCH_SHOW_SUCCESS,
  FETCH_SHOW_FAILURE,
} from './action-types'

import graphql from '../graphql'

function loadShowData () {
  return {
    type: FETCH_SHOW_DATA,
  }
}

function loadShowDataSuccess (data) {
  return {
    type: FETCH_SHOW_SUCCESS,
    data,
  }
}

function loadShowDataFailure (e) {
  return {
    type: FETCH_SHOW_FAILURE,
    error: e,
  }
}


export function getSingleShowData (showId) {
  return (dispatch) => {
    dispatch(loadShowData())
    return graphql(`{
      show(showId: "${showId}"){
        showId
        title
        description
        parentalRating
        image {
          mediumHD
        }
        categoriesConnection {
          categories {
            title
          }
        }
        seasonsConnection {
          seasons {
            id
            title
            episodesConnection {
              episodes {
                id
                number
                title
                description
                duration
                video {
                  videoId
                }
              }
            }
          }
        }
      }
    }`).then((response) => {
      const show = response.data.show

      show.seasonsConnection.seasons.sort((a, b) => a.number - b.number)

      show.seasonsConnection.seasons.forEach((season) => {
        season.episodesConnection.episodes.sort((a, b) => a.number - b.number)
      })

      dispatch(loadShowDataSuccess(response.data.show))
    })
    .catch((e) => {
      dispatch(loadShowDataFailure(e))
    })
  }
}
