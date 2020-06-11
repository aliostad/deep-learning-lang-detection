export const ADD_ITEM = 'ADD_ITEM';
export const DELETE_ITEM = 'DELETE_ITEM';
export const DELETE_ITEMS = 'DELETE_ITEMS';
export const UPDATE_ITEM = 'UPDATE_ITEM';
export const UPDATE_ITEMS = 'UPDATE_ITEMS';


export function addItem({
    text,
    id
}) {
    return dispatch => {
        dispatch({
            type: ADD_ITEM,
            id,
            text
        })
    }
}

export function deleteItem(id) {
    return dispatch => {
        dispatch({
            type: DELETE_ITEM,
            id
        })
    }
}

export function updateItem(data) {
    return dispatch => {
        dispatch({
            type: UPDATE_ITEM,
            data
        })
    }
}

export function deleteItems(list) {
    return dispatch => {
        dispatch({
            type: DELETE_ITEMS,
            list
        })
    }
}
export function updateItems(data) {
    return dispatch => {
        dispatch({
            type: UPDATE_ITEMS,
            data
        })
    }
}
export function getStatus(status) {
    return dispatch => {
        dispatch({
            type: status
        })
    }
}