/**
 * 
 * @creatTime 上午10:26:25
 * @author Eddy
 */
package tiger.test.loop;

import org.eddy.tiger.TigerBean;
import org.eddy.tiger.TigerBeanManage;
import org.eddy.tiger.impl.TigerBeanManageImpl;
import org.junit.Test;

/**
 * @author Eddy
 *
 */
public class LoopTest {

	@Test
	public void test() {
		TigerBeanManage manage = new TigerBeanManageImpl();
		TigerBean<Bear> bearBean = manage.createBean(Bear.class);
		manage.createBean(Snake.class);
		Bear bear = manage.getReference(bearBean);
		bear.bear();
	}
}
