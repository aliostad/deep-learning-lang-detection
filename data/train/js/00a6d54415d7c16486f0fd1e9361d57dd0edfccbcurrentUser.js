export const GET_CURRENT_USER = 'GET_CURRENT_USER'
export const LOGIN = 'LOGIN'
export const LOGOUT = 'LOGOUT'

//
// action creators
//

export function getCurrentUser() {
  return {
    type: GET_CURRENT_USER
  }
}

export function login(user, pass) {
  return dispatch => {
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
