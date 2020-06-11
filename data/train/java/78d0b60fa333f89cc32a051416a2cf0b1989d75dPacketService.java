package com.fengtuo.healthcare.service;

import com.fengtuo.healthcare.extractor.HealthRecordExtractor;
import com.fengtuo.healthcare.model.Packet;
import com.fengtuo.healthcare.repository.PacketRepository;

/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 2/21/13
 * Time: 8:59 PM
 * To change this template use File | Settings | File Templates.
 */
public class PacketService {
    public PacketRepository getPacketRepository() {
        return packetRepository;
    }

    public void setPacketRepository(PacketRepository packetRepository) {
        this.packetRepository = packetRepository;
    }

    private PacketRepository packetRepository;

    public PacketService(PacketRepository packetRepository){
        this.packetRepository = packetRepository;
    }

    public PacketService() {
    }

    public void savePacket(byte[] packetStream){
        Packet packet = HealthRecordExtractor.extract(packetStream);
        packetRepository.save(packet);
    }
}
