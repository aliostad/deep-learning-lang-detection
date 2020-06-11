package cn.voicet.ybh.dao;

import cn.voicet.ybh.util.DotSession;
import cn.voicet.ybh.web.form.YbhManageForm;

public interface YbhManageDao extends BaseDao{
	public final static String SERVICE_NAME = "cn.voicet.ybh.dao.impl.YbhManageDaoImpl";
	void getYbhListByCurBM(DotSession ds);
	void getYbhFamilyDetailInfo(DotSession ds);
	void getFamilyIncome(DotSession ds);
	void saveFamilyInfo(DotSession ds, YbhManageForm ybhManageForm);
	void saveMemberInfo(DotSession ds, YbhManageForm ybhManageForm);
	void deleteMemberInfo(DotSession ds, YbhManageForm ybhManageForm);
	void saveYearInfo(DotSession ds, YbhManageForm ybhManageForm);
	void saveYbhIncome(YbhManageForm ybhManageForm);
	String findNavListStr(DotSession ds);
	void getReportFamilyInfo(DotSession ds);
	String addYbhByHM(YbhManageForm ybhManageForm);
}
