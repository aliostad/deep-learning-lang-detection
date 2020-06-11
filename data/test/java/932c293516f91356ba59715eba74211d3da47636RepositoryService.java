package com.ejushang.spider.erp.service.repository;

import com.ejushang.spider.domain.Repository;
import com.ejushang.spider.domain.Storage;
import com.ejushang.spider.domain.User;
import com.ejushang.spider.erp.common.mapper.RepositoryMapper;
import com.ejushang.spider.erp.common.mapper.StorageMapper;
import com.ejushang.spider.query.RepositoryQuery;
import com.ejushang.spider.service.repository.IRepositoryService;
import com.ejushang.spider.util.Page;
import com.ejushang.spider.util.SessionUtils;
import com.ejushang.spider.vo.RepositoryVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * User: tin
 * Date: 13-12-23
 * Time: 上午11:47
 */
@Service("repositoryService")
@Transactional
public class RepositoryService implements IRepositoryService {
    private static final Logger log = LoggerFactory.getLogger(RepositoryService.class);

//依赖注入区
    /**
     * 依赖注入仓库数据层RepositoryMapper
     */
    @Autowired
    private RepositoryMapper repositoryMapper;

    @Autowired
    private StorageMapper storageMapper;

    @Autowired

//===============================================

    //     查询区

    /**
     * 查询所有仓库信息
     *
     * @return 返回Repository类型的List
     */
    @Transactional(readOnly = true)
    @Override
    public List<Repository> findRepository() {

        return repositoryMapper.findRepository();
    }


    //     查询区

    /**
     * 查询所有仓库信息
     *
     * @return 返回Repository类型的List
     */
    @Transactional(readOnly = true)
    @Override
    public List<RepositoryVo> findRepositoryAll() {
        List<RepositoryVo> repositoryVoList = new ArrayList<RepositoryVo>();
        RepositoryVo repositoryVo = null;
        List<Repository> repositoryList = repositoryMapper.findRepository();
        for (Repository repository : repositoryList) {
            repositoryVo = new RepositoryVo();
            repositoryVo.setId(repository.getId());
            repositoryVo.setName(repository.getName());
            repositoryVoList.add(repositoryVo);
        }

        return repositoryVoList;
    }


    /**
     * 通过id查询仓库信息
     *
     * @param id 仓库实体信息
     * @return 返回Repository类型
     */
    @Transactional(readOnly = true)
    @Override
    public Repository findRepositoryById(Integer id) {
        if (log.isInfoEnabled()) {
            log.info("RepositoryService findRepositoryById通过ID{" + id.toString() + "}查询");
        }
        return this.repositoryMapper.findRepositoryById(id);
    }

    @Override
    public Repository findRepositoryByName(String name) {
        return repositoryMapper.findRepositoryByName(name);
    }

    /**
     * 查询以Repository为条件的仓库信息
     *
     * @param repository 条件仓库实体信息
     * @return 返回Repository类型的List列表
     */
    @Transactional(readOnly = true)
    public Page findRepositoryByRepository(RepositoryQuery repository) {
        if (log.isInfoEnabled()) {
            log.info("RepositoryService findRepositoryByRepository通过repository{" + repository.toString() + "}实现查询");
        }
        User user = SessionUtils.getUser();
        Integer checknum = 0;
        if (null != user) {
            if (null != user.getRepoId() && !checknum.equals(user.getRepoId())) {

                repository.setId(user.getRepoId() + "");
            }
        }
        // 构造分页信息
        Page page = new Page();
        // 设置当前页
        page.setPageNo(repository.getPage());
        // 设置分页大小
        page.setPageSize(repository.getLimit());

        repositoryMapper.findRepositoryByRepositoryQuery(repository, page);

        return page;

    }


    /**
     * 查询以prodId为条件的仓库信息
     *
     * @param prodId 商品Id查询条件
     * @return 返回仓库对象
     */
    @Transactional(readOnly = true)
    public Repository findRepositoryByProdId(Integer prodId) {
        if (log.isInfoEnabled()) {
            log.info("RepositoryService findRepositoryByProdId通过prodId{" + prodId + "}查询仓库");
        }

        Storage str = storageMapper.findStorageByProdId(prodId);
        if (null == str) {
            str = new Storage();

        }

        return repositoryMapper.findRepositoryById(str.getRepoId());


    }
//    =======================================================
//    更新区

    /**
     * 更新仓库
     *
     * @param repository 实体仓库信息
     */
    @Transactional
    @Override
    public Integer updateRepository(Repository repository) {
        if (log.isInfoEnabled()) {
            log.info("RepositoryService updateRepository通过repository" + repository.toString() + "}实现更新");
        }
        if (null == repositoryMapper.findRepositoryById(repository.getId())) {
            return 0;
        } else {
            return repositoryMapper.updateRepository(repository);
        }
    }


//========================================================
//    删除区

    /**
     * 通过id删除仓库信息
     *
     * @param ids 仓库id数组
     */
    @Transactional
    @Override
    public Integer deleteRepositoryById(Integer[] ids) {
        if (log.isInfoEnabled()) {
            log.info("RepositoryService deleteRepositoryById通过ID{" + ids + "}删除");
        }
        int result = 1;


        for (int i = 0; i < ids.length; i++) {
            List<Storage> storageList = storageMapper.findStorageByRepoId(ids[i]);
            if (storageList.size() > 0) {
                return 2;
            }
            repositoryMapper.deleteRepositoryById(ids[i]);
            storageMapper.deleteStorageByRepoId(ids[i]);
        }
        return result;
    }
//=======================================================
//    插入区

    /**
     * 插入仓库数据
     *
     * @param repository 仓库实体信息
     */
    @Transactional
    @Override
    public Integer saveRepository(Repository repository) {
        if (log.isInfoEnabled()) {
            log.info("Repository saveRepository通过对象repository{" + repository.toString() + "}实现save");
        }
        if (repositoryMapper.findRepositoryCountByNameAndCode(repository) != 0) {
            return 2;
        } else {
            return repositoryMapper.saveRepository(repository);
        }
    }
//==========================================================

}
