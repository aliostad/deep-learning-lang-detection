/**
*@author Xingze Guo
*push message to each informmation area
*/

var Message = {


	pushMessage:function(newMessage){

		$("#messageArea").prepend("<p>"+newMessage+"</p>");
		console.log("new is  "+ newMessage);

	}


	// message: new Array(),
	// 'message': [],

	// init:function(){
	// 	this.message = new Array()
	// },
	// //put new message into message[]
	// addNew:function(newMessage){
	// 	var newM = new Array(1);
	// 	newM[0] = newMessage;
	// 	tempMessage = this.message;
	// 	this.message = newM.concat(tempMessage);
	// 	console.log(this.message + "in add");

	// 	for(var i=0;i<this.message.length;i++){
	// 		$("#messageArea").
	// 	}
	// 	// return this.message;
	// },

	// //return message array
	// getMessage:function(){
	// 	console.log(this.message+"message");
	// 	console.log(this.message.length+"length");
	// 	return this.message;
	// }

	// document.write(message);
};

// var testPushMessage= Object.create(pushMessage);
// testPushMessage.init();

// testPushMessage.addNew(1);
 // console.log(pushMessage.getMessage());
// console.log(pushMessage.message);
// testPushMessage.addNew(2);
 // console.log(pushMessage.getMessage());
// console.log(pushMessage.message);
// testPushMessage.addNew(3);
 // console.log(pushMessage.getMessage());
// console.log(pushMessage.message);
// testPushMessage.addNew(4);
 // console.log(pushMessage.getMessage());
// console.log(pushMessage.message);
// testPushMessage.addNew(5);
 // console.log(pushMessage.getMessage());
// console.log(pushMessage.message);
// testPushMessage.addNew(6);

// testPushMessage.addNew(1);
 // console.log(pushMessage.getMessage());
// console.log(pushMessage.message);
// testPushMessage.addNew(2);
 // console.log(pushMessage.getMessage());
// console.log(pushMessage.message);
// testPushMessage.addNew(3);
 // console.log(pushMessage.getMessage());
// console.log(pushMessage.message);
// testPushMessage.addNew(4);
 // console.log(pushMessage.getMessage());
// console.log(pushMessage.message);
// testPushMessage.addNew(5);
 // console.log(pushMessage.getMessage());
// console.log(pushMessage.message);
// testPushMessage.addNew(6);

 // console.log(pushMessage.getMessage());
// console.log(pushMessage.message);