package com.glennbech.bakemyday.repository;

/**
 * Created with IntelliJ IDEA.
 *
 * @author Glenn Bech
 */

public class RepositoryFactory {

    static boolean isTestContext;

    static {
        isTestContext = false;
    }

    public static UserProfileRepository createUserProfileRepository() {
        return new UserProfileRepositoryImpl();
    }

    public static FormulaRepository createFormulaRepository() {
        return new FormulaRepositoryImpl();
    }

    public static NotificationRepository createNotificationRepository() {
        return new NotificationRepositoryImpl();
    }

}
