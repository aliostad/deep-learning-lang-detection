package cn.voicet.ybh.service;

import cn.voicet.ybh.util.DotSession;
import cn.voicet.ybh.web.form.YbhManageForm;

public interface YbhManageService {
	public final static String SERVICE_NAME = "cn.voicet.ybh.service.impl.YbhManageServiceImpl";
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
