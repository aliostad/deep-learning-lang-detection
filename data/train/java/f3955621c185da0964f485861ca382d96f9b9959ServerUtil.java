package net.openright.infrastructure.server;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.NCSARequestLog;
import org.eclipse.jetty.server.handler.RequestLogHandler;
import org.eclipse.jetty.server.handler.StatisticsHandler;

public class ServerUtil {

	public static Handler createRequestLogHandler(Handler handler) {
		RequestLogHandler requestLogHandler = new RequestLogHandler();
        requestLogHandler.setRequestLog(createRequestLog());
        requestLogHandler.setHandler(handler);
		return requestLogHandler;
	}

	private static NCSARequestLog createRequestLog() {
		NCSARequestLog requestLog = new NCSARequestLog("logs/yyyy_mm_dd.request.log");
        requestLog.setPreferProxiedForAddress(true);
        requestLog.setRetainDays(3);
        requestLog.setAppend(true);
        requestLog.setLogTimeZone("UTC+01:00");
        requestLog.setExtended(false);
        requestLog.setLogLatency(true);
		return requestLog;
	}

	public static Handler createStatisticsHandler(Handler handler) {
        StatisticsHandler statisticsHandler = new StatisticsHandler();
        statisticsHandler.setHandler(handler);
		return statisticsHandler;
	}

}
