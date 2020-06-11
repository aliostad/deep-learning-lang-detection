import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

import * as actionCreators from '../actions/PhoneAction';
import Main from './../components/Main';

const mapStateToProps = (state) => ({
    phones: state.phones,
    status: state.status
})

/**
 * function mapDispatchToProps(dispatch) {
 *   return bindActionCreators(actionCreators, dispatch);
 * }
 */
const mapDispatchToProps = dispatch => {
    return bindActionCreators(actionCreators, dispatch)
}

export default connect(
    mapStateToProps,
    mapDispatchToProps
)(Main);
