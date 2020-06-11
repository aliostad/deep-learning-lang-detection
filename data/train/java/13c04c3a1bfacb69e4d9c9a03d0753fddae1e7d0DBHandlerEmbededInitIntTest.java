package org.audit4j.handler.db.Int;

import org.audit4j.handler.db.DatabaseAuditHandler;
import org.junit.Test;

public class DBHandlerEmbededInitIntTest {

    @Test
    public void testInitWithDefaultMode() {
        DatabaseAuditHandler handler = new DatabaseAuditHandler();
        handler.init();
        handler.stop();
    }

    @Test
    public void testInitWithPooled() {
        DatabaseAuditHandler handler = new DatabaseAuditHandler();
        handler.setDb_connection_type("pooled");
        handler.setDb_datasourceClass("org.hsqldb.jdbc.JDBCDataSource");
        handler.init();
        handler.stop();
    }

    @Test
    public void testInitWithAuth() {
        // DatabaseAuditHandler handler = new DatabaseAuditHandler();
        // handler.setDb_user("Audit4j");
        // handler.setDb_password("@uD!T4j");
        // handler.init();
        // handler.stop();
    }
}
