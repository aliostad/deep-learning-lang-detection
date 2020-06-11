package com.seafazer.core.engine.bridge;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.seafazer.core.autodetector.api.AutodetectorService;
import com.seafazer.core.autopilot.api.AutopilotService;
import com.seafazer.core.camera.api.CameraService;
import com.seafazer.core.config.api.FileConfigService;
import com.seafazer.core.config.api.PropertyService;
import com.seafazer.core.gear.api.GearService;
import com.seafazer.core.lighting.api.LightingService;
import com.seafazer.core.logbook.api.LogbookService;
import com.seafazer.core.messaging.api.MessagingService;
import com.seafazer.core.mission.api.MissionService;
import com.seafazer.core.positioning.api.GpsPositioningService;

public class Seafazer {

	public final Logger log = LoggerFactory.getLogger(getClass());

	public final AutodetectorService autodetectorService;

	public final AutopilotService autopilotService;

	public final CameraService cameraService;

	public final FileConfigService fileConfigService;

	public final PropertyService propertyService;

	public final GearService gearService;

	public final LightingService lightingService;

	public final LogbookService logbookService;

	public final MessagingService messagingService;

	public final MissionService missionService;

	public final GpsPositioningService gpsPositioningService;

	public Seafazer(AutodetectorService autodetectorService,
			AutopilotService autopilotService, CameraService cameraService,
			FileConfigService fileConfigService,
			PropertyService propertyService, GearService gearService,
			LightingService lightingService, LogbookService logbookService,
			MessagingService messagingService, MissionService missionService,
			GpsPositioningService gpsPositioningService) {
		this.autodetectorService = autodetectorService;
		this.autopilotService = autopilotService;
		this.cameraService = cameraService;
		this.fileConfigService = fileConfigService;
		this.propertyService = propertyService;
		this.gearService = gearService;
		this.lightingService = lightingService;
		this.logbookService = logbookService;
		this.messagingService = messagingService;
		this.missionService = missionService;
		this.gpsPositioningService = gpsPositioningService;
	}

}
