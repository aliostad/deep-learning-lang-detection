import {connect} from 'react-redux'
import {fetchLogin, fetchLogout, update} from '../../redux/user'
import {fetchRefresh} from '../../redux/devices'
import Session from '../../components/Session'

const mapStateToProps = (state, ownProps) => ({
  user: state.user,
})

const mapDispatchToProps = (dispatch, ownProps) => ({
  userUpdate: user => dispatch(update(user)),
  login: user => dispatch(fetchLogin(user)),
  logout: () => dispatch(fetchLogout()),
  devicesRefresh: user => dispatch(fetchRefresh(user)),
})

const Container = connect(mapStateToProps, mapDispatchToProps)(Session)

export default Container
