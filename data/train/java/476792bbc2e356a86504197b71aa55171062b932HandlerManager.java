package com.fromnibly.api;

import com.fromnibly.api.use.CodecHandler;
import com.fromnibly.api.use.DirectionHandler;
import com.fromnibly.api.use.KeyHandler;
import com.fromnibly.api.use.TypeHandler;
import lombok.Getter;
import lombok.Setter;

/**
 * Created by thato_000 on 3/13/2015.
 */
@Getter
@Setter
public class HandlerManager<T> {
    private DirectionHandler<T> directionHandler;
    private KeyHandler<T> keyHandler;
    private CodecHandler<T> codecHandler;
    private TypeHandler<T> typeHandler;
}
