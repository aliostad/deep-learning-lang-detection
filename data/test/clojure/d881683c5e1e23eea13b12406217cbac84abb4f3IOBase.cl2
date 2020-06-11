def IOBase(this){
	
	def downloadFrom(downloadFromUrl){
		this.writer().for(downloadFromUrl.stream())
	}
	
	def stream(filter:<v|v>){
		var streamReader = this.reader();
		if(streamReader.type == "error"){
			streamReader
		}
		var i;
		var r = [];
		while(true){
			i = streamReader();
			if(i == -1){
				r
			}else{
				r.push(filter(i));
			}
		}
	}
	
	def writeString(rawString, format:"ASCII"){
		this.writer().for(array(rawString.getBytes(format)));
		this
	}
	
	def writeFormattedString(format, rawString){
		this.writeString(rawString, format)
	}
	
	def buildString(format:"ASCII"){
		java("java.lang.String")(byte.for(this.stream()), format)
	}
	
	this.push(downloadFrom, "downloadFrom");
	this.push(stream, "stream");
	this.push(writeString, "writeString");
	this.push(buildString, "buildString");
	this.push(writeFormattedString, "writeFormattedString");
	
}