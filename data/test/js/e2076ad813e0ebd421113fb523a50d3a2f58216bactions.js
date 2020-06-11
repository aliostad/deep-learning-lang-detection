export const SET_LOCATION = 'SET_LOCATION'
export const SET_OPEN = 'SET_OPEN'
export const SET_DISTANCE = 'SET_DISTANCE'
export const SET_CENTER = 'SET_CENTER'
export const INIT_RECYCLING_CENTERS = 'INIT_RECYCLING_CENTERS'

export const setLocation = ({ dispatch }, location) => dispatch(SET_LOCATION, location)
export const setOpen = ({ dispatch }, open) => dispatch(SET_OPEN, open)
export const setDistance = ({ dispatch }, distance) => dispatch(SET_DISTANCE, distance)
export const setCenter = ({ dispatch }, recyclingCenter) => dispatch(SET_CENTER, recyclingCenter)
export const initRecyclingCenters = ({ dispatch }, recyclingCenters) => dispatch(INIT_RECYCLING_CENTERS, recyclingCenters)
