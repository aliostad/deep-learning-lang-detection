package ntu.csie.fingerBand.server.connect;

import java.nio.channels.SocketChannel;

import ntu.csie.fingerBand.server.connect.packet.InvitationAddedHandler;
import ntu.csie.fingerBand.server.connect.packet.InvitationDeletedHandler;
import ntu.csie.fingerBand.server.connect.packet.InvitationRequestHandler;
import ntu.csie.fingerBand.server.connect.packet.InvitationResponedHandler;
import ntu.csie.fingerBand.server.connect.packet.PacketHandler;

public class InvitationServiceHandlerFactory implements ServiceHandlerFactory{
	public ServiceHandler createServiceHandler(SocketChannel handle) {
		ServiceHandler serviceHandler = new InvitationServiceHandler(handle);
		PacketHandler packetHandler = createPacketHandlerChain(serviceHandler);
		serviceHandler.setPacketHandler(packetHandler);
		return serviceHandler;
	}

	
	public PacketHandler createPacketHandlerChain(ServiceHandler serviceHandler) {

		PacketHandler invitationAddedHandler = new InvitationAddedHandler(serviceHandler);
		PacketHandler invitationRequestHandler = new InvitationRequestHandler(serviceHandler);
		PacketHandler invitationResponedHandler = new InvitationResponedHandler(serviceHandler);
		PacketHandler invitationDeletedHandler = new InvitationDeletedHandler(serviceHandler);

		invitationAddedHandler.setNextPacketHandler(invitationRequestHandler);
		invitationRequestHandler.setNextPacketHandler(invitationResponedHandler);
		invitationResponedHandler.setNextPacketHandler(invitationDeletedHandler);
		
		return invitationAddedHandler;
	}
}
