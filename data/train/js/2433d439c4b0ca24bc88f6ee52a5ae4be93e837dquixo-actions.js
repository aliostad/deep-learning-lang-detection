'use strict'

let Dispatcher = require('src/dispatcher/dispatcher')

let QuixoActions = {
    prepareRelease() {
        Dispatcher.dispatch({
            type: 'QUIXO_PREPARERELEASE_ACTION'
        })
    },
    prepareDrop(action) {
        Dispatcher.dispatch({
            type: 'QUIXO_PREPAREDROP_ACTION',
            data: {
                action
            }
        })
    },
    drop(action) {
        Dispatcher.dispatch({
            type: 'QUIXO_DROP_ACTION',
            data: {
                action
            }
        })
    },
    release() {
        Dispatcher.dispatch({
            type: 'QUIXO_RELEASE_ACTION'
        })
    },
    pick(chessman) {
        Dispatcher.dispatch({
            type: 'QUIXO_PICK_ACTION',
            data: {
                chessman
            }
        })
    }
}

module.exports = QuixoActions
