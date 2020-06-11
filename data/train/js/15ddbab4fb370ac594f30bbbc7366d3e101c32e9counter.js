import { store } from '../index.jsx';
let dispatch = store.dispatch;

export function add() {
    console.log(333);
    // return (dispatch, getState) => {
        // Http.post('trade/payTypeList',params).then(function (data) {
        //      dispatch({
        //        type: 'payTypeList',
        //        code: data.code,
        //        data:  data.data
        //      });
        //    })
        setTimeout(()=>{
            dispatch({ type: 'ADD' });
        },1000)
        
    // }
}

export function sub() {
    // return (dispatch, getState) => {
        // Http.post('trade/payTypeList',params).then(function (data) {
        //      dispatch({
        //        type: 'payTypeList',
        //        code: data.code,
        //        data:  data.data
        //      });
        //    })
        dispatch({ type: 'SUB' });
    // }
}


