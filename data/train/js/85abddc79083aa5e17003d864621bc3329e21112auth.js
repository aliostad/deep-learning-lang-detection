import * as authActions from "../actions/creators/auth"
import Fetch from "../../../data/Fetch"
import * as notificationsActions from "./notifications"

export function attemptAuth(token) {
    return async (dispatch) => {
        dispatch(authActions.loading())
        dispatch(authActions.clearError())

        try {  
            let accessLevel = await Fetch.post("/api/auth/login", {token})

            dispatch(authActions.success(accessLevel))
        } catch (e) {
            dispatch(authActions.error(e))
            dispatch(notificationsActions.add("Invalid password — try again."))
        } finally {
            dispatch(authActions.loaded())
        }
    }
}
