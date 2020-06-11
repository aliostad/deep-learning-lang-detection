import { connect as reactReduxConnect } from 'react-redux'

let enableEventsInDispatchMapping = (events, reduxStore) => reduxStore.dispatch.events = events;

let connect = (mapStateToProps, mapEventsToProps) => {
    if (mapEventsToProps != null) {
        let mapDispatchToProps = (dispatch, ownProps) => mapEventsToProps(dispatch.events, ownProps);

        return reactReduxConnect(mapStateToProps, mapDispatchToProps);
    } else {
        return reactReduxConnect(mapStateToProps);
    }
};

export { enableEventsInDispatchMapping, connect };
