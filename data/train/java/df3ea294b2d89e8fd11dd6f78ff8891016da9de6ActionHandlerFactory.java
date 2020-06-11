package dk.diku.lindsgaard.relation;

/**
 * Created by rel on 7/28/14.
 */
public class ActionHandlerFactory {
    private static ActionHandlerFactory ourInstance = new ActionHandlerFactory();

    public static ActionHandlerFactory getInstance() {
        return ourInstance;
    }

    private ActionHandlerFactory() {
    }

    public static ActionHandler createActionHandler(String name) {
        ActionHandler actionHandler = null;
        if(name.equals("scm")) {

        }
        return actionHandler;
    }
}
