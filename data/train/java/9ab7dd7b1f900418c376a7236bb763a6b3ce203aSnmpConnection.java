package org.inuua.snmp;

import org.inuua.snmp.types.SnmpMessage;

public interface SnmpConnection {

    void registerIncomingSnmpMessageHandler(IncomingSnmpMessageHandler msgHandler);

    void registerIncomingVariableBindingsHandler(IncomingVariableBindingsHandler mibMapHandler);

    void registerIOExceptionHandler(IOExceptionHandler exceptionHandler);

    void retrieveAllObjectsStartingFrom(String objectIdentifier);

    void retrieveOneObject(String objectIdentifier);

    void sendSnmpMessage(SnmpMessage msg);

    void unRegisterIncomingSnmpMessageHandler(IncomingSnmpMessageHandler msgHandler);

    void unRegisterIncomingVariableBindingsHandler(IncomingVariableBindingsHandler mibMapHandler);

    void unRegisterIOExceptionHandler(IOExceptionHandler exceptionHandler);

    void close();
}
