import $ from 'jquery';

const load = (username) => {
  return (dispatch) => {
    dispatch({type: 'AMV/START_LOAD'});
    $.ajax({
      type: 'GET',
      url: '/api/amv/' + (username != undefined ? `?username=${username}` : ''),
      dataType: 'JSON',
    }).then((data) => {
      dispatch({type: 'AMV/END_LOAD', data: data});
    });
  }
}

const remove = (id) => {
  return (dispatch) => {
    dispatch({type: 'AMV/START_REMOVE', id: id});
    $.ajax({
      type: 'DELETE',
      url: `/api/amv/${id}/`,
      success: () => {
        dispatch({type: 'AMV/END_REMOVE'});
        dispatch({type: 'SEARCH_MODAL/REMOVE_FROM_LIBRARY', id: id})
      }
    })
  }
};

const filter = (query) => ({
  type: 'AMV/FILTER',
  query: query
});

export { load, remove, filter }
