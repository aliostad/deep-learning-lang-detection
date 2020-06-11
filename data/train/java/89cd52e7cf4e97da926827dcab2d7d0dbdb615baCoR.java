package ua.cor;

import ua.cor.handlers.*;

/**
 * Created with Intellij IDEA.
 * User: Mychajlo Godovanjuk
 * Date: 6/17/13
 * Time: 6:44 PM
 */
public class CoR {
    private static CoR ourInstance = new CoR();
    private DefaultHandler root;

    public static CoR getInstance() {
        return ourInstance;
    }

    private CoR() {
        addHandler(new LoginHandler());
        addHandler(new BuyHandler());
        addHandler(new ConfirmHandler());
        addHandler(new RegisterHandler());
        addHandler(new AddTourHandler());
        addHandler(new RemoveTourHandler());
        addHandler(new RemoveHotelHandler());
        addHandler(new AddHotelHandler());
    }

    public DefaultHandler handle(String action){
        return root.handle(action);
    }

    private void addHandler(DefaultHandler handler){
        handler.setNextHandler(root);
        root=handler;
    }
}
