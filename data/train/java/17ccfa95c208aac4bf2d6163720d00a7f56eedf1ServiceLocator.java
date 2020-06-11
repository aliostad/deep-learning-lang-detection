package ro.scene.hq.holidays.domain;

import ro.scene.hq.holidays.domain.repository.HolidayRequestRepository;
import ro.scene.hq.holidays.domain.repository.IdentityRepository;

public class ServiceLocator {

    private static HolidayRequestRepository holidayRequestRepository;

    private static IdentityRepository identityRepository;

    private static NotificationChannel notificationChannel;

    public static HolidayRequestRepository getHolidayRequestRepository() {
        return holidayRequestRepository;
    }

    public static void setHolidayRequestRepository(HolidayRequestRepository holidayRequestRepository) {
        ServiceLocator.holidayRequestRepository = holidayRequestRepository;
    }

    public static IdentityRepository getIdentityRepository() {
        return identityRepository;
    }

    public static void setIdentityRepository(IdentityRepository identityRepository) {
        ServiceLocator.identityRepository = identityRepository;
    }

    public static NotificationChannel getNotificationChannel() {
        return notificationChannel;
    }

    public static void setNotificationChannel(NotificationChannel notificationChannel) {
        ServiceLocator.notificationChannel = notificationChannel;
    }
}
