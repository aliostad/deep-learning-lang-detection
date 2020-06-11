package egovframework.bopr.jim.service;

import java.util.List;

/**
 * FTP연동관리에 대한 Vo 클래스
 * @author 배치운영환경 김지완
 * @since 2012.07.16
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2012.07.16  김지완          최초 생성
 *
 * </pre>
 */

public class FtpIntrlManageVO extends FtpIntrlManage {

	private static final long serialVersionUID = 1L;

	List <FtpIntrlManageVO> ftpIntrlManageList;

	/**
	 * FtpIntrlManage 를 리턴한다.
	 * @return FtpIntrlManage
	 */
	public FtpIntrlManage getFtpIntrlManage()
    {
    	return getFtpIntrlManage();
    }
	/**
	 * FtpIntrlManage 값을 설정한다.
	 * @param ftpIntrlManage FtpIntrlManage
	 */	
    public void setFtpIntrlManage(FtpIntrlManage ftpIntrlManage)
    {
    	setFtpIntrlManage(ftpIntrlManage);
    }

	/**
	 * ftpIntrlManageList attribute 를 리턴한다.
	 * @return List<FtpIntrlManageVO>
	 */
	public List<FtpIntrlManageVO> getFtpIntrlManageList() {
		return ftpIntrlManageList;
	}

	/**
	 * ftpIntrlManageList attribute 값을 설정한다.
	 * @param ftpIntrlManageList List<FtpIntrlManageVO> 
	 */
	public void setFtpIntrlManageList(List<FtpIntrlManageVO> ftpIntrlManageList) {
		this.ftpIntrlManageList = ftpIntrlManageList;
	}



}