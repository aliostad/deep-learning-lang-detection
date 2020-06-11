package ee.pinger.database;

import java.util.List;

public class PingerTrend {

	private final Repository mySqlPingRepository;
	private final Repository filePingRepository;

	public PingerTrend(Repository mySqlPingRepository,
			Repository filePingRepository) {
		this.mySqlPingRepository = mySqlPingRepository;
		this.filePingRepository = filePingRepository;
	}

	public void generate() {
		List<Ping> pings = mySqlPingRepository.readAll();
		for (Ping ping : pings) {
			filePingRepository.write(ping);
		}
	}

}
