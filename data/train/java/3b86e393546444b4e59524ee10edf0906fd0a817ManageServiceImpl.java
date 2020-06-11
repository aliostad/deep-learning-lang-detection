package cm.service.impl;


import cm.commons.service.impl.BaseServiceImpl;
import cm.commons.util.MDCoder;
import cm.dao.ManageDao;
import cm.entity.Manage;
import cm.service.ManageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 管理员Service的实现类
 *
 * @author li hong
 */
@Service
@Transactional
@SuppressWarnings("unchecked")
public class ManageServiceImpl extends BaseServiceImpl<Manage> implements ManageService {
    @Autowired
    private ManageDao manageDao;

    public Manage login(String number, String password) {
        password = MDCoder.encodeMD5Hex(password);
        return manageDao.login(number, password);
    }

    public Manage findByNumber(String number) {

        return manageDao.findByNumber(number);
    }


} 
