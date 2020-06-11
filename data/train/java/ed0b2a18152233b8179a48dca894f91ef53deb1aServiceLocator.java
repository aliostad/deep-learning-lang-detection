package net.sourceforge.subsonic.service;

/**
 * Locates services for objects that are not part of the Spring context.
 *
 * @author Sindre Mehus
 */
public class ServiceLocator {

    private static SettingsService settingsService;
    private static SecurityService securityService;

    private ServiceLocator() {
    }

    public static SettingsService getSettingsService() {
        return settingsService;
    }

    public static void setSettingsService(SettingsService settingsService) {
        ServiceLocator.settingsService = settingsService;
    }

    public static SecurityService getSecurityService() {
        return securityService;
    }

    public static void setSecurityService(SecurityService securityService) {
        ServiceLocator.securityService = securityService;
    }
}

