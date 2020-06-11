package com.joerghelwig.javaPatterns.chainofresponsibility;

public class AudioFileHandler implements Handler {
	
	private Handler handler;
	private String handlerName;
	
	public AudioFileHandler(String handlerName){
		this.handlerName = handlerName;
	}
	
	public void setHandler(Handler handler) {
		this.handler = handler;
	}

	public void process(File file) {

		if(file.getFileType().equals("audio")){
			System.out.println("Process and saving audio file... by "+handlerName);
		}else if(handler!=null){
			System.out.println(handlerName+" fowards request to "+handler.getHandlerName());
			handler.process(file);
		}else{
			System.out.println("File not supported");
		}
		
	}

	public String getHandlerName() {
		return handlerName;
	}

}
