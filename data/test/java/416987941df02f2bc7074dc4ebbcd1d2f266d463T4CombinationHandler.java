package dbutils;

import dbutils.combhandler.CombHandler;
import org.apache.commons.dbutils.ResultSetHandler;
import play.libs.F;
import play.utils.FastRuntimeException;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * User: wenzhihong
 * Date: 12-10-15
 * Time: 下午5:13
 */
public class T4CombinationHandler<A, B, C, D> implements ResultSetHandler<F.T4<A, B, C, D>> {
    ResultSetHandler<A> aHandler;
    ResultSetHandler<B> bHandler;
    ResultSetHandler<C> cHandler;
    ResultSetHandler<D> dHandler;

    public T4CombinationHandler(ResultSetHandler<A> a, ResultSetHandler<B> b, ResultSetHandler<C> c, ResultSetHandler<D> d) {
        if (a instanceof CombHandler
                && b instanceof CombHandler
                && c instanceof CombHandler
                && d instanceof CombHandler) {

            this.aHandler = a;
            this.bHandler = b;
            this.cHandler = c;
            this.dHandler = d;
        } else {
            throw new FastRuntimeException("这里必须是CombHandler类型, 请查阅util.combhandler包里的handler类型");
        }
    }


    @Override
    public F.T4<A, B, C, D> handle(ResultSet rs) throws SQLException {
        if (rs.next()) {
            A objA = aHandler.handle(rs);
            B objB = bHandler.handle(rs);
            C objC = cHandler.handle(rs);
            D objD = dHandler.handle(rs);
            return new F.T4(objA, objB, objC, objD);
        } else {
            return null;
        }
    }
}
