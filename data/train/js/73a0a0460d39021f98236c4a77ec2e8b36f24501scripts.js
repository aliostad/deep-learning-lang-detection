var pigLatin = function (message) {
	var vowelMatch = /^[AEIOUaeiou]/;
	var consonantMatch = /^[bcdfghjklmnpqrstvxyz]*/;
	var quMatch = /^qu/;
	var consonantQuMatch = /^[bcdfghjklmnprstvxyz]*qu/;
	for (var index = 0; index < message.length; index++) {
		if (vowelMatch.test(message)) {
			message = message + "ay";
			return message;
		} else if (quMatch.test(message)) {
			var match = quMatch.exec(message);
			message = message.replace(match, "");
			message = message + match + "ay";
			return message;
		} else if (consonantQuMatch.test(message)) {
			var match = consonantQuMatch.exec(message);
			message = message.replace(match, "");
			message = message + match + "ay";
			return message;
		} else if (consonantMatch.test(message)) {
			var match = consonantMatch.exec(message);
			message = message.replace(match,"");
			message = message + match + "ay";	
			return message;
		} 

	}
	
};

