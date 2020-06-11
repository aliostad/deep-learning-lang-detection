package org.motechproject.admin.security;

/**
 * Contains constants used for securing parts of the admin module.
 */
public final class SecurityConstants {

    public static final String MANAGE_MESSAGES = "hasRole('manageMessages')";
    public static final String MANAGE_BUNDLES = "hasRole('manageBundles')";
    public static final String MANAGE_LOGS = "hasRole('manageLogs')";
    public static final String MANAGE_ACTIVEMQ = "hasRole('manageActivemq')";
    public static final String MANAGE_SETTINGS = "hasRole('manageSettings')";

    private SecurityConstants() {
    }
}
