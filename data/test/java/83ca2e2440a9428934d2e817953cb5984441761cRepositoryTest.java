package com.ejushang.spider.erp.service.Repository;

import com.ejushang.spider.domain.Repository;
import com.ejushang.spider.erp.service.test.ErpTest;
import com.ejushang.spider.query.RepositoryQuery;
import com.ejushang.spider.service.repository.IRepositoryService;
import junit.framework.Assert;
import org.junit.Test;
import org.springframework.test.annotation.Rollback;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * User: tin
 * Date: 13-12-24
 * Time: 下午3:42
 */
@Transactional
public class RepositoryTest extends ErpTest {

    @Resource(name = "repositoryService")
    private IRepositoryService repositoryService;


    //查询区

    /**
     * 查询所有仓库数据
     */
//    @Test
//    @Rollback(false)
//    public void findRepository() {
//        ArrayList<Repository> list = (ArrayList<Repository>) this.repositoryService.findRepository();
//
//
//    }
         @Test
         public void findRepositoryByRepository(){

             RepositoryQuery re=new RepositoryQuery();
             re.setLimit(5);
             re.setPage(2);

                          repositoryService.findRepositoryByRepository(re);
//             ArrayList<Repository> list= (ArrayList<Repository>) repositoryService.findRepositoryByRepository(re);
//             System.out.println(list.size());

         }
    /**
     * 通过id查询数据
     */
//    @Test
//    @Transactional
//    @Rollback(false)
//    public void findRepositoryById() {
//        Repository re = this.repositoryService.findRepositoryById(2);
//
//
//    }
    //------------------------------------------------------

    //插入区
    @Test
    @Rollback(false)
    public void saveRepository() {
        Repository re = new Repository();
        re.setName("123121223131");
        re.setRepoCode("3");
        re.setAddress("333");
        re.setChargePerson("tt");
        re.setChargePersonId(3);
        re.setChargeMobile("11");
        re.setChargePhone("11");
        Integer che = repositoryService.saveRepository(re);

        if (che == 0) {
            Assert.assertEquals("返回代码" + che + "已存在仓库", true);
        }
        List<Repository> repositoryList = repositoryService.findRepository();
        repositoryService.findRepositoryById(re.getId());
        Assert.assertEquals(1, repositoryList.size());
        Repository res = new Repository();
        res.setId(re.getId());
//        repositoryService.findRepositoryByRepository(res);
        res.setAddress("jssjks");
        Integer upda = repositoryService.updateRepository(res);
        if (upda == 0) {
            Assert.assertEquals("返回代码" + upda + "需更新的数据被删除", true);
        }
//        repositoryService.deleteRepositoryById(re.getId());
        List<Repository> repositoryList1 = repositoryService.findRepository();
        Assert.assertEquals(0, repositoryList1.size());




    }


    //-----------------------------------------------------

//    //更新区
//    @Test
//    @Rollback(false)
//    public void updateRepository() {
//        Repository re = new Repository();
//        re.setName("23333");
//        re.setRepoCode("333");
//        re.setAddress("333");
//        re.setChargePerson("333");
//        re.setChargePersonId(3333);
//        re.setChargePhone("33333");
//        re.setId(4);
//
//
//        repositoryService.updateRepository(re);
//
//
//    }
@Test
public void update(){

    Repository re=new Repository();
    re.setId(1);
    re.setName("老伙计");
    repositoryService.updateRepository(re);

}
    //---------------------------------------------------

    //删除区
//    @Test
//    @Rollback(false)
//    public void deleteRepository() {
//        repositoryService.deleteRepositoryById(1);
//
//    }
    //--------------------------------------------------

}
