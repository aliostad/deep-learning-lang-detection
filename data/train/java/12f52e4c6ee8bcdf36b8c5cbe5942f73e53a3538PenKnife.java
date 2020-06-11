package io.patryk;

/**
 * Created by Patryk Poborca on 9/18/2015.
 */
public final class PenKnife <I extends PenKnifeHandler>{

    private static PenKnife penKnife;
    public static <I extends PenKnifeHandler>void initialize(I handler){
        penKnife = new PenKnife(handler);
    }

    public static PenKnife getInstance(){
        return penKnife;
    }

    private final I handler;

    private PenKnife(I handler){
        this.handler = handler;
    }

    public I getHandler(){
        return handler;
    }

}
