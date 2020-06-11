package egovframework.com.uss.ion.yrc.service.impl;

import java.util.List;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.uss.ion.yrc.service.IndvdlYrycManage;

import org.springframework.stereotype.Repository;

/**
 * 개요
 * - 연차관리에 대한 DAO 클래스를 정의한다.
 *
 * 상세내용
 * - 연차관리에 대한 등록, 수정, 삭제, 조회 기능을 제공한다.
 * @author 이기하
 * @version 1.0
 * @created 2014.11.14
 */

@Repository("indvdlYrycDAO")
public class IndvdlYrycDAO extends EgovComAbstractDAO {

	/**
	 * 연차를 조회처리한다.
	 * @param indvdlYrycManage - 연차관리 model
	 */
	@SuppressWarnings("unchecked")
	public List<IndvdlYrycManage> selectIndvdlYrycManageList(IndvdlYrycManage indvdlYrycManage) throws Exception {
		return (List<IndvdlYrycManage>)list("indvdlYrycDAO.selectIndvdlYrycManageList", indvdlYrycManage);
	}

	/**
	 * 연차목록 총 갯수를 조회한다.
	 * @param indvdlYrycManage - 연차관리 model
	 */
	public int selectIndvdlYrycManageListTotCnt(IndvdlYrycManage indvdlYrycManage) throws Exception {
		return (Integer)select("indvdlYrycDAO.selectIndvdlYrycManageListTotCnt", indvdlYrycManage);
	}

	/**
	 * 연차를 입력처리한다.
	 * @param indvdlYrycManage - 연차관리 model
	 */
	public void insertIndvdlYrycManage(IndvdlYrycManage indvdlYrycManage) throws Exception {
		insert("indvdlYrycDAO.insertIndvdlYrycManage", indvdlYrycManage);
	}

	/**
	 * 연차를 수정처리한다.
	 * @param indvdlYrycManage - 연차관리 model
	 */
	public void updtIndvdlYrycManage(IndvdlYrycManage indvdlYrycManage) throws Exception {
		update("indvdlYrycDAO.updateIndvdlYrycManage", indvdlYrycManage);
	}

	/**
	 * 연차를 삭제처리한다.
	 * @param indvdlYrycManage - 연차관리 model
	 */
	public void deleteIndvdlYrycManage(IndvdlYrycManage indvdlYrycManage) throws Exception {
		delete("indvdlYrycDAO.deleteIndvdlYrycManage", indvdlYrycManage);
	}

}
