package org.oiue.service.odp.base;

import java.util.Dictionary;

import org.oiue.service.log.LogService;
import org.oiue.service.odp.proxy.ProxyFactory;
import org.oiue.service.osgi.FrameActivator;
import org.oiue.service.osgi.MulitServiceTrackerCustomizer;
import org.oiue.service.sql.SqlService;

public class Activator extends FrameActivator {

    @Override
    public void start() throws Exception {
        this.start(new MulitServiceTrackerCustomizer() {
            private FactoryService factoryService;

            @Override
            public void removedService() {}

            @Override
            public void addingService() {
                LogService logService = getService(LogService.class);
                SqlService sqlService = (SqlService) getService(SqlService.class);

                ProxyFactory pf = ProxyFactory.getInstance();
                pf.getOp().setDs(new ProxyDBSourceImpl(sqlService, logService));
                pf.setLogService(logService);

                factoryService = new FactoryServiceImpl(pf);

                registerService(FactoryService.class, factoryService);
            }

            @Override
            public void updated(Dictionary<String, ?> props) {

            }
        }, LogService.class, SqlService.class);
    }

    @Override
    public void stop() throws Exception {}
}
