package de.craut;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import de.craut.domain.ActivityPointRepository;
import de.craut.domain.ActivityRepository;
import de.craut.domain.FileUploadRepository;
import de.craut.domain.RoutePointRepository;
import de.craut.domain.RouteRepository;
import de.craut.service.ActivityService;
import de.craut.service.RouteService;

@Configuration
@EnableAutoConfiguration
@Profile("test")
public class ServiceTestContext {

	@Bean
	public RouteService routeService(RouteRepository routeRepository, RoutePointRepository routePointRepository, FileUploadRepository fileUploadRepository) {
		return new RouteService(routeRepository, routePointRepository, fileUploadRepository);
	}

	@Bean
	public ActivityService activityService(ActivityRepository activityRepository, ActivityPointRepository activityPointRepository,
	        RouteRepository routeRepository, RoutePointRepository routePointRepository) {
		return new ActivityService(activityRepository, activityPointRepository, routeRepository, routePointRepository);
	}

}
