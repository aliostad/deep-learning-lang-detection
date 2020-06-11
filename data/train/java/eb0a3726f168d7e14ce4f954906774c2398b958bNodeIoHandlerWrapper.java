
package com.mediatek.mediatekdm.iohandler;

import com.mediatek.mediatekdm.mdm.MdmException;
import com.mediatek.mediatekdm.mdm.NodeIoHandler;

public abstract class NodeIoHandlerWrapper implements NodeIoHandler {
    private NodeIoHandler mHandler;

    public NodeIoHandlerWrapper(NodeIoHandler handler) {
        mHandler = handler;
    }
    
    public NodeIoHandlerWrapper() {
        this(null);
    }
    
    public void setHandler(NodeIoHandler handler) {
        mHandler = handler;
    }

    @Override
    public int read(int offset, byte[] data) throws MdmException {
        return mHandler.read(offset, data);
    }

    @Override
    public void write(int offset, byte[] data, int totalSize) throws MdmException {
        mHandler.write(offset, data, totalSize);
    }

}
