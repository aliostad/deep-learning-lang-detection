package cn.mariojd.base;


import cn.mariojd.service.*;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Created by Mario
 */
public class BaseController {

    @Autowired
    protected UserService userService;

    @Autowired
    protected MessageService messageService;

    @Autowired
    protected SeckillService seckillService;

    @Autowired
    protected OrderService orderService;

    @Autowired
    protected AdminService adminService;

    @Autowired
    protected ReadService readService;

    @Autowired
    protected NoticeService noticeService;

}
