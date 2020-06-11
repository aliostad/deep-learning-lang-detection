import { connect as reduxConnect } from 'react-redux';

function getStateProps(mapStateToPropsDefault, extra, ...args) {
    if (extra) {
        return (state, ownProps) => ({
            ...mapStateToPropsDefault(...args)(state, ownProps),
            ...extra(...args)(state, ownProps)
        });
    }

    return (state, ownProps) => mapStateToPropsDefault(...args)(state, ownProps);
}

function getDispatchProps(mapDispatchToPropsDefault, extra, ...args) {
    if (extra) {
        return (dispatch, ownProps) => ({
            ...mapDispatchToPropsDefault(...args)(dispatch, ownProps),
            ...extra(...args)(dispatch, ownProps)
        });
    }

    return (dispatch, ownProps) => mapDispatchToPropsDefault(...args)(dispatch, ownProps);
}

export default (stateDefault, dispatchDefault) => (...args) => (extraState = null, extraDispatch = null) => {
    const mapStateToProps = getStateProps(stateDefault, extraState, ...args);
    const mapDispatchToProps = getDispatchProps(dispatchDefault, extraDispatch, ...args);

    return reduxConnect(mapStateToProps, mapDispatchToProps);
};

