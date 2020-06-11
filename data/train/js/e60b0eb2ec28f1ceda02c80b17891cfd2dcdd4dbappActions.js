import store from '../../redux/store';

export function openMenu() {
  store.dispatch({
    type: 'OPEN_MENU',
  });
}
export function closeMenu() {
  store.dispatch({
    type: 'CLOSE_MENU',
  });
}

export function toggleDimmer() {
  store.dispatch({
    type: 'TOGGLE_DIMMER',
  });
}

export function toggleEmergencyFriends() {
  store.dispatch({
    type: 'TOGGLE_EMERGENCY_FRIENDS',
  });
}

export function toggleEmergencyServices() {
  store.dispatch({
    type: 'TOGGLE_EMERGENCY_SERVICES',
  });
}

export function toggleSpeedDial() {
  store.dispatch({
    type: 'TOGGLE_SPEED_DIAL',
  });
}

export function toggleTotemModal(bool) {
  store.dispatch({
    type: 'TOGGLE_TOTEM_MODAL',
    payload: bool
  });
}
