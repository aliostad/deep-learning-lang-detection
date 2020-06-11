package com.gof.iteration4.algo;

import com.gof.customer.data.TypeOfData;
import com.gof.iteration4.algo.handlers.*;

import java.util.HashMap;
import java.util.Map;

/**
* Created by vitaliypopov on 25.11.14.
*/
public class DefaultAlgoResolver implements IAlgoResolver {
    public static final IAlgoHandler NULL_DATA_HANDLER = new NullAlgoHandler();
    public static final IAlgoHandler LIVE_HANDLER = new LiveAlgoHandler();
    public static final IAlgoHandler PREPARED_HANDLER = new PreparedAlgoHandler();
    public static final IAlgoHandler FAKE_HANDLER = new FakeAlgoHandler();
    public static final IAlgoHandler ERR_HANDLER = new ErrAlgoHandler();

    private static Map<Object, IAlgoHandler> registeredHandlers = new HashMap<>(TypeOfData.values().length);
    static {
        for (TypeOfData datatype : TypeOfData.values()) {
            registerAlgoHandler(datatype, matchingDefaultHandler(datatype));
        }
    }

    @Override
    public IAlgoHandler resolveAlgo(final TypeOfData dataType) {
        return registeredHandlers.get(dataType);
    }

    private static IAlgoHandler matchingDefaultHandler(final TypeOfData dataType) {
        IAlgoHandler handler = null;
        switch (dataType) {
            case LIVE:
                handler = LIVE_HANDLER;
                break;
            case PREPARED:
                handler = PREPARED_HANDLER;
                break;
            case FAKE:
                handler = FAKE_HANDLER;
                break;
            case ERR:
                handler = ERR_HANDLER;
                break;
            default:
                handler = NULL_DATA_HANDLER;
        }
        return handler;
    }

    public static IAlgoHandler registerAlgoHandler(final TypeOfData dataType, final IAlgoHandler algoHandler) {
        return registeredHandlers.put(dataType, algoHandler);
    }

    public static IAlgoHandler unregisterAlgoHandler(final TypeOfData dataType) {
        return registeredHandlers.put(dataType, NULL_DATA_HANDLER);
    }
}
