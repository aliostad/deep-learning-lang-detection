import pages, {actions} from '../config/pages'

export default (...arg) => {
    var action = {
        SIGNIN({dispatch}, user) { //登录
            dispatch('SIGNIN', user)
        },
        SIGNOUT({dispatch}) { //退出
            dispatch('SIGNOUT')
        },
        MSG_NUM({dispatch}, ...arg) { //设置用户消息数量
            dispatch('MSG_NUM', ...arg)
        },
        UPDATE_LOADING({dispatch}) { //显示加载
            dispatch('UPDATE_LOADING')
        },
        UPDATE_DIRECTION({dispatch}) { //切换动作
            dispatch('UPDATE_DIRECTION')
        }

    }
    /**
     * 更新用户的消息数量
     */

    const newPage = (name) => { //设置页面行为
        if (!name) return
        for (let i = 0; i < actions.length; i++) {
            action[actions[i]] = function ({dispatch}, ...arg) {
                dispatch(`${name}${actions[i]}`, ...arg)
            }
        }
    }
    newPage(...arg) //创建页面对应的action
    return action
}
