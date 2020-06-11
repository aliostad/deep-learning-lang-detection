import * as types from '../mutation-types'
/**
 * 面包屑导航的状态
 */
const state = {
  navList: []
}

const mutations = {
  [types.TOP_NAV_CHANGE] (state, nav) {
    state.navList = [nav]
  },
  [types.SUB_NAV_CHANGE] (state) {

  },
  [types.SUB_NAV_ADD] (state, nav) {
    if (nav) state.navList.push(nav)
  },
  [types.SUB_NAV_DETAIL] (state, nav) {
    if (nav) state.navList.push(nav)
  },
  [types.SUB_NAV_MODIFY] (state, nav) {
    if (nav) state.navList.push(nav)
  },
  [types.SUB_NAV_REMOVE] (state) {
        // 此方法移除导航列表中最后一项
    let list = state.navList
    let len = list.length
    if (len > 1) list.splice(len - 1, 1)
  }
}

export default {
  state,
  mutations
}
