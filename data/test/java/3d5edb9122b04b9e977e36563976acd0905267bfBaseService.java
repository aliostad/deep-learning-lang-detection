package cn.mariojd.base;

import cn.mariojd.repository.*;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Created by Mario
 */
public class BaseService {

    @Autowired
    protected UserRepository userRepository;

    @Autowired
    protected MessageRepository messageRepository;

    @Autowired
    protected SeckillRepository seckillRepository;

    @Autowired
    protected OrderRepository orderRepository;

    @Autowired
    protected AdminRepository adminRepository;

    @Autowired
    protected NoticeRepository noticeRepository;

    @Autowired
    protected ReadRepository readRepository;

}
