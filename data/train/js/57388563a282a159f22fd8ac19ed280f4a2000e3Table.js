import {connect} from 'react-redux';
import Table from '../views/Table';
import {
    fetchTeachers,
    editTeacherServer,
    deleteTeacherServer} from '../actions';

const mapStateToDispatch = ({teachers, language}) => {
    return {
        teachers: teachers.data,
        lang: language.lang
    };
};

const mapDispatchToProps = (dispatch) => {
    return {
        getData: () => {
            dispatch(fetchTeachers());
        },
        onDelete: (teacher) => {
            dispatch(deleteTeacherServer(teacher));
        },
        onEdit: (teacher) => {
            dispatch(editTeacherServer(teacher));
        }
    };
};

export default connect(mapStateToDispatch, mapDispatchToProps)(Table);