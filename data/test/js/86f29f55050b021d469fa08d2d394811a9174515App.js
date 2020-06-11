import {connect} from 'react-redux'
import App from '../components/App'
import {updateSettings} from '../actions/menu'
import {resetGame} from '../actions/game'
import {DEFAULT_SETTINGS} from '../constants'

const mapStateToProps = ({settings}) => ({
  settings
})

const mapDispatchToProps = (dispatch, {settings}) => ({
  setBeginner: () => dispatch(updateSettings(DEFAULT_SETTINGS.BEGINNER)),
  setIntermediate: () => dispatch(updateSettings(DEFAULT_SETTINGS.INTERMEDIATE)),
  setExpert: () => dispatch(updateSettings(DEFAULT_SETTINGS.EXPERT)),
  resetGame: () => dispatch(resetGame(settings))
})

export default connect(mapStateToProps, mapDispatchToProps)(App)