package com.caocao.core.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.caocao.core.dao.FinanceManageMapper;
import com.caocao.core.model.FinanceManage;
import com.caocao.core.service.FinanceManageService;

@Service("financeManageService")
public class FinanceManageServiceImpl implements FinanceManageService {

	@Resource
	private FinanceManageMapper financeManageMapper;
	
	public List<FinanceManage> SelectBigCustomerAccountStat(FinanceManage financeManage) {
		List<FinanceManage> list = financeManageMapper.SelectBigCustomerAccountStat(financeManage);
		return list;
	}
	
	public List<FinanceManage> SelectBusinesTotalIncomeStat(FinanceManage financeManage) {
		List<FinanceManage> list = financeManageMapper.SelectBusinesTotalIncomeStat(financeManage);
		return list;
	}
	
	public List<FinanceManage> SelectPlatRewardStat(FinanceManage financeManage) {
		List<FinanceManage> list = financeManageMapper.SelectPlatRewardStat(financeManage);
		return list;
	}
	
	public List<FinanceManage> SelectDriverIncome(FinanceManage financeManage) {
		List<FinanceManage> list = financeManageMapper.SelectDriverIncome(financeManage);
		return list;
	}
}
