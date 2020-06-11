import Network from '../Network'

export const UPLOAD_PHOTO = 'UPLOAD_PHOTO'

//
// action creators
//

export function updatePicture(data) {
  return {
    type: 'UPDATE_PICTURE',
    ...data
  }
}

export function uploadPhotoAsync() {
  return (dispatch, getState) => {
    dispatch(updatePicture({id, loading: true}))
    Network.put(`pictures/${id}`)
      .then(response => {
        return response.json()
      })
      .then(data => {
        console.log(data)
        dispatch(updatePicture({id, loading: false}))
      })
  }

}

export function getEmbedsAsync(id) {
  return (dispatch, getState) => {
    Network.get('embeds')
      .then(response => {
        return response.json()
      })
      .then(data => {
        dispatch(showEmbeds(data))
      })
  }
}

export function showEmbeds(embeds) {
  return {
    type: SHOW_EMBEDS,
    embeds
  }
}



export function createEmbed(data, history) {
  return (dispatch, getState) => {
    Network.post('embeds', data)
    .then(response => {
      return response.json()
    })
    .then(data => {
      history.pushState(null, `/embeds/${data.id}`)
    })

  }
}

// export function getCurrentUserAsync() {
//   return dispatch => {
//     // dispatch optimistic update
//     setTimeout(() => {
//       // dispatch final update
//       dispatch(test(`${text} async`))
//     }, 1000)
//   }
// }
// 
// export function testAsync(text) {
//   return dispatch => {
//     // dispatch optimistic update
//     dispatch(test(text))
//     setTimeout(() => {
//       // dispatch final update
//       dispatch(test(`${text} async`))
//     }, 1000)
//   }
// }
// 



