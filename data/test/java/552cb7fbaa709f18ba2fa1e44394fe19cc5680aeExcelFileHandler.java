package com.joerghelwig.javaPatterns.chainofresponsibility;

public class ExcelFileHandler implements Handler{
	
	private Handler handler;
	private String handlerName;
	
	public ExcelFileHandler(String handlerName){
		this.handlerName = handlerName;
	}
	
	public void setHandler(Handler handler) {
		this.handler = handler;
	}

	public void process(File file) {

		if(file.getFileType().equals("excel")){
			System.out.println("Process and saving excel file... by "+handlerName);
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
