package net.openright.infrastructure.server;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Slf4jRequestLog;
import org.eclipse.jetty.server.handler.RequestLogHandler;
import org.eclipse.jetty.server.handler.StatisticsHandler;

public class ServerUtil {

    public static Handler createRequestLogHandler(Handler handler) {
        RequestLogHandler requestLogHandler = new RequestLogHandler();
        requestLogHandler.setRequestLog(new Slf4jRequestLog());
        requestLogHandler.setHandler(handler);
        return requestLogHandler;
    }

    public static Handler createStatisticsHandler(Handler handler) {
        StatisticsHandler statisticsHandler = new StatisticsHandler();
        statisticsHandler.setHandler(handler);
        return statisticsHandler;
    }

}
