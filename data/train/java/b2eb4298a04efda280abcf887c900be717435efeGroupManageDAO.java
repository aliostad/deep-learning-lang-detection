package egovframework.let.sec.gmt.service.impl;

import java.util.List;

import egovframework.let.sec.gmt.service.GroupManage;
import egovframework.let.sec.gmt.service.GroupManageVO;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

import org.springframework.stereotype.Repository;

/**
 * 그룹관리에 대한 DAO 클래스를 정의한다.
 * @author 공통서비스 개발팀 이문준
 * @since 2009.06.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.03.11  이문준          최초 생성
 *   2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성
 *
 * </pre>
 */

@Repository("groupManageDAO")
public class GroupManageDAO extends EgovAbstractDAO {

	/**
	 * 검색조건에 따른 그룹정보를 조회
	 * @param groupManageVO GroupManageVO
	 * @return GroupManageVO
	 * @exception Exception
	 */
	public GroupManageVO selectGroup(GroupManageVO groupManageVO) throws Exception {
		return (GroupManageVO) select("groupManageDAO.selectGroup", groupManageVO);
	}

	/**
	 * 시스템사용 목적별 그룹 목록 조회
	 * @param groupManageVO GroupManageVO
	 * @return GroupManageVO
	 * @exception Exception
	 */
	@SuppressWarnings("unchecked")
	public List<GroupManageVO> selectGroupList(GroupManageVO groupManageVO) throws Exception {
		return (List<GroupManageVO>) list("groupManageDAO.selectGroupList", groupManageVO);
	}

	/**
	 * 그룹 기본정보를 화면에서 입력하여 항목의 정합성을 체크하고 데이터베이스에 저장
	 * @param groupManage GroupManage
	 * @exception Exception
	 */
	public void insertGroup(GroupManage groupManage) throws Exception {
		insert("groupManageDAO.insertGroup", groupManage);
	}

	/**
	 * 화면에 조회된 그룹의 기본정보를 수정하여 항목의 정합성을 체크하고 수정된 데이터를 데이터베이스에 반영
	 * @param groupManage GroupManage
	 * @exception Exception
	 */
	public void updateGroup(GroupManage groupManage) throws Exception {
		update("groupManageDAO.updateGroup", groupManage);
	}

	/**
	 * 불필요한 그룹정보를 화면에 조회하여 데이터베이스에서 삭제
	 * @param groupManage GroupManage
	 * @exception Exception
	 */
	public void deleteGroup(GroupManage groupManage) throws Exception {
		delete("groupManageDAO.deleteGroup", groupManage);
	}

    /**
	 * 롤목록 총 갯수를 조회한다.
	 * @param groupManageVO GroupManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectGroupListTotCnt(GroupManageVO groupManageVO) throws Exception {
        return (Integer)select("groupManageDAO.selectGroupListTotCnt", groupManageVO);
    }
}