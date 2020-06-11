package com.mnknowledge.dp.behavioral.chainofresponsibility.atm;

public class BGNATM {

    private static HundredsProcessorHandler hundredsHandler = new HundredsProcessorHandler("BGN");
    private static FiftiesProcessorHandler fiftiesHandler = new FiftiesProcessorHandler("BGN");
    private static TwentiesProcessorHandler twentiesHandler = new TwentiesProcessorHandler("BGN");
    private static TensProcessorHandler tensHandler = new TensProcessorHandler("BGN");
    private static FivesProcessorHandler fivesHandler = new FivesProcessorHandler("BGN");

    public BGNATM() {
        super();
        // Prepare the chain of Handlers
        hundredsHandler.nextHandler(fiftiesHandler);
        fiftiesHandler.nextHandler(twentiesHandler);
        twentiesHandler.nextHandler(tensHandler);
        tensHandler.nextHandler(fivesHandler);

    }

    public void withdraw(long requestedAmount) {

        hundredsHandler.dispatch(requestedAmount);
    }
}
