package fm.liu.timo.net.handler;

import fm.liu.timo.net.connection.BackendConnection;
import fm.liu.timo.server.session.handler.ResultHandler;
import fm.liu.timo.server.session.handler.SessionResultHandler;

public class InnerCreateConnectionHandler extends BackendCreateConnectionHandler {
    private String        sql;
    private ResultHandler handler;

    public InnerCreateConnectionHandler(String sql, ResultHandler handler) {
        this.sql = sql;
        this.handler = handler;
    }

    @Override
    public void connecFailed(String reason) {
        handler.close(reason);
    }

    @Override
    public void connectSuccess(BackendConnection con) {
        if (handler instanceof SessionResultHandler) {
            ((SessionResultHandler) handler).session.offer(con);
        }
        con.query(sql, handler);
    }
}
