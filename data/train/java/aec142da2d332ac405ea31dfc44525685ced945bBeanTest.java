/**
 * 
 * @creatTime 下午8:59:17
 * @author Eddy
 */
package tiger.test.field;

import org.eddy.tiger.TigerBean;
import org.eddy.tiger.TigerBeanManage;
import org.eddy.tiger.impl.TigerBeanManageImpl;
import org.junit.Test;

/**
 * @author Eddy
 *
 */
public class BeanTest {

	@Test
	public void test() {
		TigerBeanManage manage = new TigerBeanManageImpl();
		TigerBean<Monkey> monkeyBean = manage.createBean(Monkey.class);
		manage.createBean(Sheep.class);
		Monkey monkey = manage.getReference(monkeyBean);
		monkey.monkey();
	}
}
