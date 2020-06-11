import player from '../api/player'
import * as types from './mutation-types'

export const playSong = types.PLAY_SONG

export const startPlaying = ({ dispatch, state }, products) => {
  dispatch(types.PLAY_SONG)
  player.playSong(
    song,
    () => dispatch(types.PLAY_SONG)
  )
}

export const getAllSongs = ({dispatch}) => {
	player.getSongs(songs => {
		() => dispatch(types.RECEIVE_SONGS)
	})
}

/*
export const getAllProducts = ({ dispatch }) => {
  shop.getProducts(products => {
    dispatch(types.RECEIVE_PRODUCTS, products)
  })
}
*/