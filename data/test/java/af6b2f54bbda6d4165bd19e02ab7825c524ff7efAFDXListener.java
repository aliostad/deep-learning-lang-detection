package com.afdxsuite.afdx;

import com.afdxsuite.core.network.AFDXPacket;
import com.afdxsuite.core.network.manager.IntegrityHandler;
import com.afdxsuite.core.network.manager.Normalizer;
import com.afdxsuite.core.network.manager.PacketHandler;
import com.afdxsuite.core.network.manager.RedundancyHandler;

import jpcap.PacketReceiver;
import jpcap.packet.Packet;

public class AFDXListener implements PacketReceiver {

	final PacketHandler _handler;
	final IntegrityHandler _integrity_handler;
	final RedundancyHandler _redundancy_handler;
	final Normalizer _normalizer;

	public AFDXListener() {
		_normalizer = new Normalizer();
		_handler = PacketHandler.getInstance();
		_integrity_handler = (IntegrityHandler) _handler;
		_redundancy_handler = (RedundancyHandler) _handler;
		
		_integrity_handler.registerRedundancyHandler(_redundancy_handler);
		_redundancy_handler.registerNormalizer(_normalizer);
		_handler.registerIntegrityHandler(_integrity_handler);
	}

	@Override
	public void receivePacket(Packet packet) {
		System.out.println("Received");
		try {
		_handler.onReceive(new AFDXPacket(packet));
		} catch(Exception ex) {
			ex.printStackTrace();
		}
		
	}

}
