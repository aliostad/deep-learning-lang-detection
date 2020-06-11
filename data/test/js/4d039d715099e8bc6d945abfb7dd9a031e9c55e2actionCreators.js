/* jshint strict: false, asi: true, esversion:6 */
import { ADD_MESSAGE } from './actions.js'
import { DELETE_MESSAGE } from './actions.js'
import { TOGGLE_EDIT } from './actions.js'
import { EDIT_MESSAGE } from './actions.js'

export function addMessage(message){
	return {type: ADD_MESSAGE, message}
}

export function deleteMessage(messageID){
	return {type: DELETE_MESSAGE, messageID}
}

export function toggleEdit(messageID){
	return {type: TOGGLE_EDIT, messageID}
}

export function editMessage(messageID, message){
	return {type: EDIT_MESSAGE, messageID, message}
}