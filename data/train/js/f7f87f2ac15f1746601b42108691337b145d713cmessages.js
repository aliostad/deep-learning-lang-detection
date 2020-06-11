import { getContact } from './contacts'

const messages = []

export const addMessage = (message) => {
	messages.push(message)
	return message.id
}

export const getMessages = () => {
	return messages
}

export const updateMessage = (id, newMessage) => {
    const currentMessage = getMessage(id)
    const index = messages.indexOf(currentMessage)
    Object.assign(newMessage, {id:id})
    messages[index] = newMessage
}

export const getMessage = (id) => {
	return messages.find((message) => message.id === id)
}

export const getCurrentId = () => {
	return messages.length > 0 ? Math.max(...messages.map((message) => message.id)) : 0
}