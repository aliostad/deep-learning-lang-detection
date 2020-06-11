package kr.co.baristaworks.contents.egov.bbs;

import java.util.List;

import kr.co.baristaworks.domain.BbsManage;
import kr.co.baristaworks.domain.BbsManageVO;
import kr.co.baristaworks.fw.service.CommonService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class BbsManageService {
  
  @Autowired
  private BbsManageMapper bbsManageMapper;
  
  @Autowired
  private CommonService commsonService;
  /*
  @Autowired
  private QueryDao queryDao;
  public List<BbsManageVO> selectBbsManageList() {
    return queryDao.selectList("BbsManageMapper.selectBbsManageList");
  }
  public int insertBbsManage(BbsManage bbsManage) {
    Long bbsId = (Long) commsonService.selectNextId("BBS_ID");
    bbsManage.setBbsId(bbsId);
    return queryDao.insert("BbsManageMapper.insertBbsManage", bbsManage);
  }
  public BbsManage selectBbsManage(String bbsId) {
    return queryDao.selectOne("BbsManageMapper.selectBbsManage", bbsId);
  }
  
  public int updateBbsManage(BbsManage bbsManage) {
    return queryDao.update("BbsManageMapper.updateBbsManage", bbsManage);
  }
   */
  public List<BbsManageVO> selectBbsManageList() {
    return bbsManageMapper.selectBbsManageList();
  }

  public int insertBbsManage(BbsManage bbsManage) {
    Long bbsId = (Long) commsonService.selectNextId("BBS_ID");
    bbsManage.setBbsId(bbsId);
    return bbsManageMapper.insertBbsManage(bbsManage); 
  }

  public BbsManage selectBbsManage(String bbsId) {
    return bbsManageMapper.selectBbsManage(bbsId);
  }
  public int updateBbsManage(BbsManage bbsManage) {
  	return bbsManageMapper.updateBbsManage(bbsManage);
  }
  
}
