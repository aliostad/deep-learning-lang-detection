package com.rchab.gof.chain.templates.cycledTemplate;

public class Client {

    private RequestHandler chain;

    public Client() {
        buildChain();
    }

    private void buildChain(){
        RequestHandler firstHandler = new RequestHandler();
        RequestHandler secondHandler = new RequestHandler();
        RequestHandler thirdHandler = new RequestHandler();

        firstHandler.setNext(secondHandler);
        secondHandler.setNext(thirdHandler);
        thirdHandler.setNext(firstHandler);
    }

    public void makeRequest(Request request){
        chain.handleRequest(request);
    }

}
