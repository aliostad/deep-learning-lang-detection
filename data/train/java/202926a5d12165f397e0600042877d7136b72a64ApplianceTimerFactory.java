package net.swapspace.apps.wd;

public class ApplianceTimerFactory {
    private DisplayHandler displayHandler;
    private NotificationHandler notificationHandler;
    private long timeTick;

    public ApplianceTimerFactory(DisplayHandler displayHandler, NotificationHandler notificationHandler, long timeTick) {
        this.displayHandler = displayHandler;
        this.notificationHandler = notificationHandler;
        this.timeTick = timeTick;
    }

    public ApplianceTimer create(int cycleLength) {
        return new ApplianceTimer(displayHandler, notificationHandler, cycleLength * timeTick, timeTick / 10);
    }
}
