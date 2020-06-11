import {connect} from 'react-redux';
import ToDoApp from '../components/ToDoApp';
import {add, subtract, reset, append} from '../reducers/modules/toDoApp';

function mapStateToProps(state) {
    return {
        toDoApp: state.toDoApp
    }
}

function mapDispatchToProps(dispatch) {
    return {
        add: () => dispatch(add()),
        subtract: () => dispatch(subtract()),
        reset : () => dispatch(reset()),
        append: (value) => dispatch(append(value))
    }
}


export default connect(
    mapStateToProps, mapDispatchToProps
)(ToDoApp);

