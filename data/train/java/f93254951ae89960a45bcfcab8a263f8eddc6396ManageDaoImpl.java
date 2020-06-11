package cm.dao.impl;


import cm.commons.dao.impl.BaseDaoImpl;
import cm.dao.ManageDao;
import cm.entity.Manage;
import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

/**
 * 课程Dao的实现类
 *
 * @author li hong
 */
@Repository
public class ManageDaoImpl extends BaseDaoImpl<Manage> implements ManageDao {
    @Override
    public Manage login(String number, String password) {
        Criteria c = getSession().createCriteria(Manage.class);
        c.add(Restrictions.eq("number", number));
        c.add(Restrictions.eq("password", password));
        return (Manage) c.uniqueResult();
    }

    @Override
    public Manage findByNumber(String number) {
        Criteria c = getSession().createCriteria(Manage.class);
        c.add(Restrictions.eq("number", number));
        return (Manage) c.uniqueResult();
    }


}
