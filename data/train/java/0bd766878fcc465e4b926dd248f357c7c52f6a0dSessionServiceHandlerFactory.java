package ntu.csie.fingerBand.server.connect;

import java.nio.channels.SocketChannel;

import ntu.csie.fingerBand.server.connect.packet.EndSessionHandler;
import ntu.csie.fingerBand.server.connect.packet.JoinSessionHandler;
import ntu.csie.fingerBand.server.connect.packet.PacketHandler;
import ntu.csie.fingerBand.server.connect.packet.QuitSessionHandler;
import ntu.csie.fingerBand.server.connect.packet.TransmitHandler;




public class SessionServiceHandlerFactory implements ServiceHandlerFactory {

//	private Session session;
	

	
	public ServiceHandler createServiceHandler(SocketChannel handle) {
		ServiceHandler serviceHandler = new SessionServiceHandler(handle);
		PacketHandler packetHandler = createPacketHandlerChain(serviceHandler);
		serviceHandler.setPacketHandler(packetHandler);
		return serviceHandler;
	}

	public PacketHandler createPacketHandlerChain(ServiceHandler serviceHandler) {
		
		PacketHandler joinSessionHandler = new JoinSessionHandler(serviceHandler);	
		PacketHandler quitSessionHandler = new QuitSessionHandler(serviceHandler);
		PacketHandler endSessionHandler = new EndSessionHandler(serviceHandler);
		PacketHandler transmitHandler = new TransmitHandler(serviceHandler);
		
		
		joinSessionHandler.setNextPacketHandler(quitSessionHandler);
		quitSessionHandler.setNextPacketHandler(endSessionHandler);
		endSessionHandler.setNextPacketHandler(transmitHandler);
		
		return joinSessionHandler;
	
	}

}
