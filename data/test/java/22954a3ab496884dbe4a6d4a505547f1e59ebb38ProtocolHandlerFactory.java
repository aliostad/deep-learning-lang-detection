package code.google.dsf.server;

import java.util.HashMap;
import java.util.Map;

import code.google.dsf.server.rpc.RPCProtocolHandler;

public class ProtocolHandlerFactory {

  public static final byte PROTOCOLHANDLER_RPC = (byte) 0x00;

  private static Map<Byte, IProtocolHandler> protocolHandlerMap =
      new HashMap<Byte, IProtocolHandler>();
  

  static {
    ProtocolHandlerFactory.registerProtocolHandler(ProtocolHandlerFactory.PROTOCOLHANDLER_RPC,
      RPCProtocolHandler.INSTANCE);
  }


  public static void registerProtocolHandler(byte type, IProtocolHandler protocolHandler) {
    protocolHandlerMap.put(Byte.valueOf(type), protocolHandler);
  }

  public static IProtocolHandler getProtocolHandler(byte type) {
    return protocolHandlerMap.get(Byte.valueOf(type));
  }
}
