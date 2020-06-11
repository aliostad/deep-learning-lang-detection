import ApiActions from '../../actions/api'
import FormActions from '../../actions/form'
import RouterActions from '../../actions/router'

const FormPluginActions = (base) => {
  const redirect = RouterActions.redirect(base)
  const actions = {
    get: ApiActions(base + '_GET'),
    post: ApiActions(base + '_POST'),
    put: ApiActions(base + '_PUT'),
    fields: FormActions(base + '_FIELDS'),
    redirect: redirect,
    dispatcher: (dispatch) => {
      return {
        dispatch: dispatch,
        update: (name, value) => dispatch(actions.fields.update(name, value)),
        touch: (name) => dispatch(actions.fields.touch(name)),
        revert: () => dispatch(actions.fields.revert()),
        cancel: () => dispatch(redirect('cancel')),
        submit: (valid) => {
          valid ?
            dispatch(actions.fields.submit()) :
            dispatch(actions.fields.touchform())
        }
      }
    }
  }

  return actions
}

export default FormPluginActions
