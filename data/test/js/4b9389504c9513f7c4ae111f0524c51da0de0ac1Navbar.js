import { connect } from 'react-redux'
import Components from 'components'
import Action from 'js/actions'

const mapStateToProps = (state) => ({
    currentUser: state.Session.AuthData,
    Profile: state.Profile
})

const mapDispatchToProps = (dispatch) => ({
    FBLogin: () => dispatch(Action.Session.FBLogin()),
    FirebaseRedirection: () => dispatch(Action.Session.FirebaseRedirection()),
    GoogleLogin: () => dispatch(Action.Session.GoogleLogin()),
    CookieLogin: (data) => dispatch(Action.Session.CookieLogin(data)),
    AuthLogout: () => dispatch(Action.Session.AuthLogout()),
    getNickName: (id) => dispatch(Action.Intern.getNickName(id))
})

export default connect(mapStateToProps, mapDispatchToProps)(Components.common.Navbar)
