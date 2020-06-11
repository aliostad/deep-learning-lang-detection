/**
 * 
 * @creatTime 下午8:14:08
 * @author Eddy
 */
package tiger.test.superinject;

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
		manage.createBean(Cow.class);
		TigerBean<Phoenix> bean = manage.createBean(Phoenix.class);
		Phoenix p = manage.getReference(bean);
		p.phoenix();
	}
}
