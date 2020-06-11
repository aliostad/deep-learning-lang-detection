import { connect } from 'react-redux'
import Form from '../../components/Form'
import { UI, API } from '../../actions'

const getOptions = () => {
  const options = []
  options.push({value: 0, label: 'Menu'})
  options.push({value: 1, label: 'Events'})
  options.push({value: 2, label: 'Content'})
  return options
}

const mapStateToProps = state => {
  return {
    page: state.app.form,
    options: getOptions()
  }
}

const getHandler = dispatch => {
  return {
    changeTitle: title => {
      dispatch(UI.changeTitle(title))
    },
    changeDescription: description => {
      dispatch(UI.changeDescription(description))
    },
    changeType: type => {
      dispatch(UI.changeType(type))
    },
    changeActive: isActive => {
      dispatch(UI.changeActive(isActive))
    },
    changePublicationDate: publishedOn => {
      dispatch(UI.changePublicationDate(publishedOn))
    },
    savePage: page => {
      dispatch(API.postPage(page))
    },
    updatePage: page => {
      dispatch(API.putPage(page))
    },
    resetPage: id => {
      dispatch(UI.resetPage(id))
    }
  }
}

const mapDispatchToProps = dispatch => {
  return {
    handler: getHandler(dispatch)
  }
}

const FormContainer = connect(
  mapStateToProps,
  mapDispatchToProps
)(Form)

export default FormContainer
