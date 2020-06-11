package com.thinkingtop.kaas.services.manage;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
@Component("recommendManage")
public class RecommendManage {
	static Logger logger=Logger.getLogger(RecommendManage.class);
	private SchemeManage schemeManage;
	private RuleManage ruleManage;
	
	public String[] getRecommend(String endUser, String scheme,
			String inputItems, int outputItemsNum, int outputQuantitye) {
		String[] Recommend = ruleManage.getRecommend(scheme,inputItems, outputItemsNum, outputQuantitye);
		return Recommend;
	}
	
	public SchemeManage getSchemeManage() {
		return schemeManage;
	}
	
	@Resource(name="schemeManage")
	public void setSchemeManage(SchemeManage schemeManage) {
		this.schemeManage = schemeManage;
	}

	public RuleManage getRuleManage() {
		return ruleManage;
	}

	@Resource(name="ruleManage")
	public void setRuleManage(RuleManage ruleManage) {
		this.ruleManage = ruleManage;
	}

}
