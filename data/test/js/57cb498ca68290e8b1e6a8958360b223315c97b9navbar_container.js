import Navbar from './navbar';
import {connect} from 'react-redux';
import {logout, login, receiveErrors} from '../../actions/session_actions';
import {requestAllAnimeLibraries} from '../../actions/anime_library_actions';

const mapStateToProps = (state) => ({
  currentUser: state.session.currentUser,
});

const mapDispatchToProps = (dispatch) => ({
    logout:() => dispatch(logout()),
    login:(user) => dispatch(login(user)),
    receiveErrors:errors => dispatch(receiveErrors(errors)),
    requestAllAnimeLibraries: () => dispatch(requestAllAnimeLibraries())
});

export default connect(mapStateToProps, mapDispatchToProps)(Navbar);
