package com.ares.knightmare.handler;

import java.util.Timer;
import java.util.TimerTask;

public class TimeHandler {

	private static final int TIME_BETWEEN_TICKS = 10;

	public TimeHandler(EntityHandler entityHandler, NormalMappedEntityHandler normalMappedEntityHandler, LightHandler lightHandler, TerrainHandler terrainHandler,
			WaterHandler waterHandler, ParticleHandler particleHandler, CameraHandler cameraHandler) {// TODO
		new Timer(true).scheduleAtFixedRate(new TimerTask() {

			@Override
			public void run() {
				entityHandler.tick(terrainHandler);
				normalMappedEntityHandler.tick();
				// lightHandler.tick();TODO
				terrainHandler.tick();
				waterHandler.tick();
				try {
					particleHandler.acquire();
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				particleHandler.tick(cameraHandler.getCamera());
				particleHandler.release();
			}
		}, 0, TIME_BETWEEN_TICKS);
	}
}
