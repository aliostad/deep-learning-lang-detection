package com.github.jfwilson.rxjson;

import java.util.function.Consumer;

public interface TypeHandlers {
    public static StrictTypeHandler onObject(TypeHandler.ObjectHandler objectHandler) {
        return new StrictTypeHandler() {
            @Override
            public ObjectHandler onObject() {
                return objectHandler;
            }
        };
    }

    public static StrictTypeHandler onArray(TypeHandler.ArrayHandler arrayHandlerHandler) {
        return new StrictTypeHandler() {
            @Override
            public ArrayHandler onArray() {
                return arrayHandlerHandler;
            }
        };
    }

    public static JavaObjectTypeHandler onAny(Consumer<Object> javaObjectHandler) {
        return new JavaObjectTypeHandler(javaObjectHandler);
    }
}
