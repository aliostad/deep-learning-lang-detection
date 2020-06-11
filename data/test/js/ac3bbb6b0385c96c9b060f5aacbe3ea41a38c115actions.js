import ganttData from '../api/ganttData'
import * as types from './mutation-types'

export const setHeaderHeight = ({ dispatch }, height) => {
  dispatch(types.SET_HEADER_HEIGHT, height)
}

export const setTableTree = ({ dispatch }, data) => {
  dispatch(types.SET_TABLE_TREE, data)
}

export const toggleTableTreeRow = ({ dispatch }, data) => {
  dispatch(types.TOGGLE_TABLE_TREE_ROW, data)
}

export const fetchGanttData = ({ dispatch }) => {
  ganttData.getData((data) => {
    dispatch(types.SET_GANTT_DATA, data)
  })
}

export const setGanttData = ({ dispatch }, data) => {
  dispatch(types.SET_GANTT_DATA, data)
}