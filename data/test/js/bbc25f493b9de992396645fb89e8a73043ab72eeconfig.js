export const types = {
    SET_API_URL: 'CONFIG/API_URL_SET'
};

let defaultApiUrl = '';

export const initialState = {
    apiUrl: defaultApiUrl
};

//reducers
export default (state = initialState, action) => {
    switch (action.type) {
        case types.SET_API_URL:
            return {
                ...state,
                apiUrl: action.apiUrl
            };
        default:
            return state
    }
}

export const actions = {
    setApiUrl: function(apiUrl){
        return function (dispatch) {
            dispatch({
                type:types.SET_API_URL,
                apiUrl: apiUrl
            });
        };
    },
};