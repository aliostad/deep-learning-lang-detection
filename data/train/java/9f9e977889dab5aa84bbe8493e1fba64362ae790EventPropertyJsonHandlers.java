/**
 * Logspace
 * Copyright (c) 2015 Indoqa Software Design und Beratung GmbH. All rights reserved.
 * This program and the accompanying materials are made available under the terms of
 * the Eclipse Public License Version 1.0, which accompanies this distribution and
 * is available at http://www.eclipse.org/legal/epl-v10.html.
 */
package io.logspace.agent.api.json;

import java.util.HashMap;
import java.util.Map;

public final class EventPropertyJsonHandlers {

    public static final EventPropertyJsonHandlers INSTANCE = new EventPropertyJsonHandlers();

    private final Map<String, EventPropertyJsonHandler<?>> handlers = new HashMap<String, EventPropertyJsonHandler<?>>();

    private final DoubleEventPropertyJsonHandler doubleHandler;
    private final BooleanEventPropertyJsonHandler booleanHandler;
    private final DateEventPropertyJsonHandler dateHandler;
    private final FloatEventPropertyJsonHandler floatHandler;
    private final IntegerEventPropertyJsonHandler integerHandler;
    private final LongEventPropertyJsonHandler longHandler;
    private final StringEventPropertyJsonHandler stringHandler;

    private EventPropertyJsonHandlers() {
        super();

        this.booleanHandler = new BooleanEventPropertyJsonHandler();
        this.addHandler(this.booleanHandler);

        this.dateHandler = new DateEventPropertyJsonHandler();
        this.addHandler(this.dateHandler);

        this.doubleHandler = new DoubleEventPropertyJsonHandler();
        this.addHandler(this.doubleHandler);

        this.floatHandler = new FloatEventPropertyJsonHandler();
        this.addHandler(this.floatHandler);

        this.integerHandler = new IntegerEventPropertyJsonHandler();
        this.addHandler(this.integerHandler);

        this.longHandler = new LongEventPropertyJsonHandler();
        this.addHandler(this.longHandler);

        this.stringHandler = new StringEventPropertyJsonHandler();
        this.addHandler(this.stringHandler);
    }

    public static BooleanEventPropertyJsonHandler getBooleanHandler() {
        return INSTANCE.booleanHandler;
    }

    public static DateEventPropertyJsonHandler getDateHandler() {
        return INSTANCE.dateHandler;
    }

    public static EventPropertyJsonHandler<Double> getDoubleHandler() {
        return INSTANCE.doubleHandler;
    }

    public static FloatEventPropertyJsonHandler getFloatHandler() {
        return INSTANCE.floatHandler;
    }

    public static EventPropertyJsonHandler<?> getHandler(String fieldName) {
        return INSTANCE.handlers.get(fieldName);
    }

    public static IntegerEventPropertyJsonHandler getIntegerHandler() {
        return INSTANCE.integerHandler;
    }

    public static LongEventPropertyJsonHandler getLongHandler() {
        return INSTANCE.longHandler;
    }

    public static StringEventPropertyJsonHandler getStringHandler() {
        return INSTANCE.stringHandler;
    }

    private void addHandler(EventPropertyJsonHandler<?> handler) {
        this.handlers.put(handler.getFieldName(), handler);
    }
}
