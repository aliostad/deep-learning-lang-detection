package ju5tas.states;

import ju5tas.states.handlers.CustomStateHandler;
import ju5tas.states.handlers.StateHandler;

public abstract class StateProcessor {

    private StateHandler handler;

    protected void setHandler(StateHandler handler) {
        this.handler = handler;
    }

    protected abstract void configure();

    public void processSymbol(char c) {
        handler = handler.execute(c);
    }

    public void loadDefault() {
        CustomStateHandler def = new CustomStateHandler();
        def.addRule(new CustomStateHandler.Rule(null, null, State.TEXT));
        setHandler(def);
    }
}
