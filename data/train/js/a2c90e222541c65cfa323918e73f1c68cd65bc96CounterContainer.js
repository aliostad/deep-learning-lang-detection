import { connect } from 'react-redux';
import { increment, multiply } from '../actions/counter';
import Counter from '../components/Counter';

const mapStateToProps = (state, ownProps) => {
    return {
        count: state.count
    };
};

const mapDispatchToProps = (dispatch, ownProps) => {
    return {
        addOne: () => {
            dispatch(increment(1));
        },
        addTwo: () => {
            dispatch(increment(2));
        },
        double: () => {
            dispatch(multiply(2));
        },
        triple: () => {
            dispatch(multiply(3));
        }
    };
};

const CounterContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(Counter);

export default CounterContainer;
