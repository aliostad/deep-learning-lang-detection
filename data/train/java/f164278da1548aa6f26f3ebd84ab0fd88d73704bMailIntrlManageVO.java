package egovframework.bopr.jim.service;

import java.util.List;

/**
 * Mail연동관리에 대한 Vo 클래스
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

public class MailIntrlManageVO extends MailIntrlManage {

	private static final long serialVersionUID = 1L;

	List <MailIntrlManageVO> mailIntrlManageList;

	/**
	 * MailIntrlManage 를 리턴한다.
	 * @return MailIntrlManage
	 */
	public MailIntrlManage getMailIntrlManage()
    {
    	return getMailIntrlManage();
    }
	/**
	 * MailIntrlManage 값을 설정한다.
	 * @param mailIntrlManage MailIntrlManage
	 */	
    public void setMailIntrlManage(MailIntrlManage mailIntrlManage)
    {
    	setMailIntrlManage(mailIntrlManage);
    }

	/**
	 * mailIntrlManageList attribute 를 리턴한다.
	 * @return List<MailIntrlManageVO>
	 */
	public List<MailIntrlManageVO> getMailIntrlManageList() {
		return mailIntrlManageList;
	}

	/**
	 * mailIntrlManageList attribute 값을 설정한다.
	 * @param mailIntrlManageList List<MailIntrlManageVO> 
	 */
	public void setMailIntrlManageList(List<MailIntrlManageVO> mailIntrlManageList) {
		this.mailIntrlManageList = mailIntrlManageList;
	}



}