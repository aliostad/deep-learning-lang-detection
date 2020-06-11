package org.ua.shop.ui.utils.handler.barcode;

/**
 * @author Yaroslav.Gryniuk
 */

public class BarcodeHandlerFactory {
    private Long delay;
    private String suffix;

    public BarCodeHandler getHandler(BarCodeHandlerEvent eventHandler) {
        BarCodeHandler handler = new BarCodeHandler(eventHandler);
        handler.setDelay(delay);
        handler.setSuffix(suffix);
        return handler;
    }

    public void setDelay(Long delay) {
        this.delay = delay;
    }

    public void setSuffix(String suffix) {
        this.suffix = suffix;
    }
}
