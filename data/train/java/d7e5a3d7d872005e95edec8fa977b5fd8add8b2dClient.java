package com.rchab.gof.chain.samples.numbersSample;

public class Client {
    RequestHandler firstHandler = new RequestHandler("First");
    RequestHandler secondHandler = new RequestHandler("Second");
    RequestHandler thirdHandler = new RequestHandler("Third");

    public Client() {
        buildChain();
    }

    private void buildChain(){
        firstHandler.setNext(secondHandler);
        secondHandler.setNext(thirdHandler);
        thirdHandler.setNext(firstHandler);
    }

    public void makeRequest(String request){
        firstHandler.handleRequest(request);
    }

}
