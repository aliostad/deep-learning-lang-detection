export default {
	state: {
		messageObj: {
			messageList: []
		}	
	},
	mutations: {
		setmessageObj (state, messageObj) {
			for (let i=0; i<messageObj.messageList.length; i++) {
		
					messageObj.messageList[i].from = HOST+'/user/header/image/small/'+messageObj.messageList[i].from
				}
			
			state.messageObj = messageObj
			console.log('commited: ' + JSON.stringify(state.messageObj))
		},
		concatMessageList (state, messageList) {
			console.log('into concatMessageList')
			for (let i=0; i<messageList.length; i++) {
				messageList[i].from = HOST + '/user/header/image/small/' + messageList[i].from
			}
			state.messageObj.messageList = state.messageObj.messageList.concat(messageList)
		}
	}
}