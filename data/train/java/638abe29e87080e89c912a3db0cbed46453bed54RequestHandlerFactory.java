package com.cafeform.iumfs;

import com.cafeform.iumfs.handler.CreateRequestHandler;
import com.cafeform.iumfs.handler.GetAttrRequestHandler;
import com.cafeform.iumfs.handler.MkdirRequestHandler;
import com.cafeform.iumfs.handler.WriteRequestHandler;
import com.cafeform.iumfs.handler.RmdirRequestHandler;
import com.cafeform.iumfs.handler.RemoveRequestHandler;
import com.cafeform.iumfs.handler.ReadDirRequestHandler;
import com.cafeform.iumfs.handler.ReadRequestHandler;
import com.cafeform.iumfs.handler.RequestHandler;
import java.nio.BufferUnderflowException;
import java.util.logging.Logger;

/**
 * Factory of RequestHander which corresponds to the request from 
 * controll device
 */
public class RequestHandlerFactory 
{
    private static final Logger logger = Logger.getLogger(RequestHandlerFactory.class.getName());
    private ReadRequestHandler readRequestHander;
    private ReadDirRequestHandler readDirRequestHandler;
    private GetAttrRequestHandler getAttrRequestHandler;
    private WriteRequestHandler writeRequestHandler;
    private CreateRequestHandler createRequestHandler;
    private RemoveRequestHandler removeRequestHandler;
    private MkdirRequestHandler mkdirRequestHandler;
    private RmdirRequestHandler rmdirRequestHandler;

    public RequestHandler getHandler (RequestType requestType)
    {
        RequestHandler handler;

            switch (requestType) {
                case READ_REQUEST:
                    if (null == readRequestHander) 
                    {
                        readRequestHander = new ReadRequestHandler();
                    }
                    handler = readRequestHander;
                    break;
                case READDIR_REQUEST:
                    if (null == readDirRequestHandler)
                    {
                        readDirRequestHandler = new ReadDirRequestHandler();
                    }
                    handler = readDirRequestHandler;
                    break;
                case GETATTR_REQUEST:
                    if (null == getAttrRequestHandler)
                    {
                        getAttrRequestHandler = new GetAttrRequestHandler();                        
                    }
                    handler = getAttrRequestHandler;
                    break;
                case WRITE_REQUEST:
                    if (null == writeRequestHandler)
                    {
                        writeRequestHandler = new WriteRequestHandler();
                    }
                    handler = writeRequestHandler;
                    break;
                case CREATE_REQUEST:
                    if (null == createRequestHandler)
                    {
                        createRequestHandler = new CreateRequestHandler();
                    }
                    handler = createRequestHandler;
                    break;
                case REMOVE_REQUEST:
                    if (null == removeRequestHandler)
                    {
                        removeRequestHandler = new RemoveRequestHandler();
                    }
                    handler = removeRequestHandler;
                    break;
                case MKDIR_REQUEST:
                    if (null == mkdirRequestHandler)
                    {
                        mkdirRequestHandler = new MkdirRequestHandler();
                    }
                    handler = mkdirRequestHandler;
                    break;
                case RMDIR_REQUEST:
                    if (null == rmdirRequestHandler)
                    {
                        rmdirRequestHandler = new RmdirRequestHandler();
                    }
                    handler = rmdirRequestHandler;
                    break;
                default:
                    logger.warning("Unknown request: " + requestType);
                    throw new UnknownRequestException();
            }
            return handler;
    } 
}
