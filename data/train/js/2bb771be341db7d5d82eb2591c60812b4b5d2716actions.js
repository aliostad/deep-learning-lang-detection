export function playPause ({ dispatch }, station) {
  dispatch('PLAY_PAUSE', station.name)
}

export function dispatchError ({ dispatch }, source, code) {
  if (source) {
    dispatch('ERROR', source, code)
  } else {
    dispatch('RESET_ERROR')
  }
}

export function updateStationsDataUrl ({ dispatch }, e) {
  dispatch('UPDATE_STATIONS_DATA_URL', e.target.value)
}

export function downloadStations ({ dispatch, state }, e) {
  dispatch('DOWNLOADING_STATIONS', true)
  fetch(state.stationsDataUrl)
    .then(response => {
      return response.json()
    }).then(json => {
      dispatch('DOWNLOADING_STATIONS', false)
      dispatch('STOP')
      dispatch('UPDATE_STATIONS', json)
    }).catch(ex => {
      dispatch('DOWNLOADING_STATIONS', false)
      dispatch('ERROR', 'fetch', 0)
      console.error('Json parsing failed', ex)
    })
}

export function resetStations ({ dispatch }) {
  dispatch('STOP')
  dispatch('UPDATE_STATIONS', false)
}
