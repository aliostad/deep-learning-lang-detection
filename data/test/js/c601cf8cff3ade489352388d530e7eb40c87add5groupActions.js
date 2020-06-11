import axios from "axios";

export function startGroupCreation() {
    return function(dispatch) {
        dispatch({type: "STARTING_NEW_GROUP"});
    }
}

export function cancelGroupCreation() {
    return function(dispatch) {
        dispatch({type: "STOP_NEW_GROUP"});
    }
}

export function createGroup(newGroupMembers) {
    return function(dispatch) {
        dispatch({type: "CREATING_GROUP"});
        // dispatch({type: "CREATE_GROUP", payload: newGroupMembers});
    }
}

export function selectNewMember(memberId) {
    return function(dispatch) {
        dispatch({type: "ADDING_NEW_MEMBER", payload: memberId});
    }
}

export function removeNewMember(memberId) {
    return function(dispatch) {
        dispatch({type: "REMOVING_NEW_MEMBER", payload: memberId});
    }
}

export function changeGroupName(chatId, newGroupName) {
    return function(dispatch) {
        dispatch({type: "CHANGING_GROUP_NAME"});

        axios.put("/api/group/" + chatId, {groupName: newGroupName})
        .then(function(groupResponse) {
            if (groupResponse.status === 200) {
                var changedGroup = {
                    chatId: chatId,
                    groupName: newGroupName
                }
                dispatch({type: "CHANGED_GROUP_NAME", payload: changedGroup});
            }
            else {
                dispatch({type: "GROUP_CHANGE_FAILED"});
            }
        })
    }
}
