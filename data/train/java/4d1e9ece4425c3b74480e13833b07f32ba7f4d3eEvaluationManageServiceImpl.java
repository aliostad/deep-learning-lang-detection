/**
 * 
 */
package com.xnjd.hynm.service.impl;

import java.util.List;

import com.xnjd.hynm.dao.EvaluationManageDao;
import com.xnjd.hynm.model.Evaluation;
import com.xnjd.hynm.service.EvaluationManageService;

/**
 * @author Administrator
 *
 */
public class EvaluationManageServiceImpl implements EvaluationManageService{
	
	private EvaluationManageDao evaluationManageDao;

	/**
	 * @param evaluationManageDao the evaluationManageDao to set
	 */
	public void setEvaluationManageDao(EvaluationManageDao evaluationManageDao) {
		this.evaluationManageDao = evaluationManageDao;
	}

	 
	public boolean addEvaluation(Evaluation evaluation){
		
		return evaluationManageDao.addEvaluation(evaluation);
	}


	/* (non-Javadoc)
	 * @see com.xnjd.hynm.service.EvaluationManageService#avgEvaluation(int)
	 */
	@Override
	//用于查询并统计评价结果
	public List<Evaluation> avgEvaluation(int event_id) {
		
		
		List<Evaluation> iter=evaluationManageDao.avgEvaluation(event_id);
		return iter;
	}
	
	
}
