/**
 * Created by gtsotsos on 2017-07-26.
 */
export function deposit(amount) {
    return function (dispatch) {
        return dispatch({
            type: 'DEPOSIT',
            timestamp: Date(),
            amount: Math.abs(amount)
        });
    };
}

export function withdraw(amount) {
    return function (dispatch) {
        return dispatch({
            type: 'WITHDRAW',
            timestamp: Date(),
            amount: Math.abs(amount)
        });
    };
}

export function reset() {
    return function (dispatch) {
        return dispatch({
            type: 'RESET'
        })
    }
}