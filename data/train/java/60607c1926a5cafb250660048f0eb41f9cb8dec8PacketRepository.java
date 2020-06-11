package com.fengtuo.healthcare.repository;

import com.fengtuo.healthcare.model.Packet;

import java.util.Date;

/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 2/21/13
 * Time: 9:01 PM
 * To change this template use File | Settings | File Templates.
 */
public class PacketRepository {

    private WaveRecordRepository waveRecordRepository;

    private UserRepository userRepository;

    private LastWaveRecordRepository lastWaveRecordRepository;

    private DigitRecordRepository digitRecordRepository;

    public PacketRepository() {
    }

    public PacketRepository(DigitRecordRepository digitRecordRepository,
                            WaveRecordRepository waveRecordRepository,
                            UserRepository userRepository,
                            LastWaveRecordRepository lastWaveRecordRepository) {
        this.digitRecordRepository = digitRecordRepository;
        this.waveRecordRepository = waveRecordRepository;
        this.userRepository = userRepository;
        this.lastWaveRecordRepository = lastWaveRecordRepository;
    }

    public void setUserRepository(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void setLastWaveRecordRepository(LastWaveRecordRepository lastWaveRecordRepository) {
        this.lastWaveRecordRepository = lastWaveRecordRepository;
    }

    public void setWaveRecordRepository(WaveRecordRepository waveRecordRepository) {
        this.waveRecordRepository = waveRecordRepository;
    }

    public void setDigitRecordRepository(DigitRecordRepository digitRecordRepository) {
        this.digitRecordRepository = digitRecordRepository;
    }

    public void save(Packet packet){
        String userId = userRepository.findUser(packet.getDeviceId());
        packet.initRecordUser(userId);
        digitRecordRepository.insert(packet.getDigitRecords());
        lastWaveRecordRepository.refreshLastWaveRecord(userId, new Date());
        waveRecordRepository.insert(packet.getWaveRecords());
    }
}
