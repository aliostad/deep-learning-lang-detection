import React from 'react';
import { connect } from 'react-redux';

import CounterComponent from './counter.component';
import { COUNTER_ACTIONS } from './counter.reducer';

function mapStateToProps(state, ownProps) {
    return {
        count : state.counter
    }
};

function mapDispatchToProps(dispatch) {
    return {
        increment: () =>{ dispatch(COUNTER_ACTIONS.INCREMENT()) },
        decrement: () =>{ dispatch(COUNTER_ACTIONS.DECREMENT()) },
    };
}

export default connect(mapStateToProps, mapDispatchToProps)(CounterComponent);