import baseActionsCreatorsFor from './baseActionsCreatorsFor'
import actions  from './utils/actionsHelpers'


function actionsCreatorsFor( resource, url) {

  const baseActions = baseActionsCreatorsFor(resource)

  let creators = {
    fetch() {
      return function(dispatch) {
        return actions.fetch( dispatch, baseActions, url)
      }
    },

    read(id) {
      return function(dispatch) {
        return actions.fetch( dispatch, baseActions, url + '/' + id)
      }
    },

    create(entity) {
      return function(dispatch) {
        return actions.create( entity, dispatch, baseActions, url)
      }
    },

    update(entity) {
      return function(dispatch) {
        return actions.update( entity, dispatch, baseActions, url)
      }
    },

    delete(entity) {
      return function(dispatch) {
        return actions.delete( entity, dispatch, baseActions, url)
      }
    }
  }

  creators = _.extend( creators, baseActions)

  return creators
}

export default  actionsCreatorsFor
