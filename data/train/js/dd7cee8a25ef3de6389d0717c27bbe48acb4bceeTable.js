import {connect} from 'react-redux';
import Table from '../views/Table.jsx';
import {
    fetchPositions,
    deletePositionServer,
    editPositionServer} from '../actions';

const mapStateToDispatch = ({teacherPositions, language}) => {
    return {
        positions: teacherPositions.data,
        lang: language.lang,
        editing: teacherPositions.options.editing
    };
};

const mapDispatchToProps = (dispatch) => {
    return {
        getData: () => {
            dispatch(fetchPositions());
        },
        onEdit: (position) => {
            dispatch(editPositionServer(position));
        },
        onDelete: (position) => {
            dispatch(deletePositionServer(position));
        },

    };
};

export default connect(mapStateToDispatch, mapDispatchToProps)(Table);