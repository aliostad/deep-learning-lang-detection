package com.will.designmodel.chainofresponsibility;

public class Handler {
	private Handler handler;

	public Handler getHandler() {
		return handler;
	}

	public void setHandler(Handler handler) {
		this.handler = handler;
	}

	public void excute() {
		if (handler != null) {
			handler.excute();
		}
	}

	public static void main(String[] args) {
		Handler handler = new Handler();
		String type = "charactera";
		if ("symbol".equals(type)) {
			handler.setHandler(new SymbolHandler());
		} else if ("number".equals(type)) {
			handler.setHandler(new NumberHandler());
		} else if ("character".equals(type)) {
			handler.setHandler(new CharacterHandler());
		} else {
			System.out.println("no handler can handle that");
			System.exit(0);
		}
		handler.excute();
	}
}
