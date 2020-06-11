export function updateSelectedFormation ({ dispatch }, event) {
  dispatch('UPDATE_SELECTED_FORMATION', event.target.value)
}

export function updatePlayer ({ dispatch }, data) {
  dispatch('UPDATE_PLAYER', data)
}

export function updatePlayerChemistry ({ dispatch }, data) {
  dispatch('UPDATE_PLAYER_CHEMISTRY', data)
}

export function updatePlayerLinks ({ dispatch }, data) {
  dispatch('UPDATE_PLAYER_LINKS', data)
}

export function updatePlayerPositions ({ dispatch }, data) {
  dispatch('UPDATE_PLAYER_POSITIONS', data)
}
