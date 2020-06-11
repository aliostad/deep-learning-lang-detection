package com.gdn.venice.facade;

import java.util.ArrayList;
import java.util.List;

import javax.ejb.Remote;

import com.gdn.venice.persistence.RafProcessInstance;
import com.djarum.raf.utilities.JPQLAdvancedQueryCriteria;
import com.gdn.venice.facade.finder.FinderReturn;

@Remote
public interface RafProcessInstanceSessionEJBRemote {

	/**
	 * queryByRange - allows querying by range/block
	 * 
	 * @param jpqlStmt
	 * @param firstResult
	 * @param maxResults
	 * @return a list of RafProcessInstance
	 */
	public List<RafProcessInstance> queryByRange(String jpqlStmt, int firstResult,
			int maxResults);

	/**
	 * persistRafProcessInstance persists a country
	 * 
	 * @param rafProcessInstance
	 * @return the persisted RafProcessInstance
	 */
	public RafProcessInstance persistRafProcessInstance(RafProcessInstance rafProcessInstance);

	/**
	 * persistRafProcessInstanceList - persists a list of RafProcessInstance
	 * 
	 * @param rafProcessInstanceList
	 * @return the list of persisted RafProcessInstance
	 */
	public ArrayList<RafProcessInstance> persistRafProcessInstanceList(
			List<RafProcessInstance> rafProcessInstanceList);

	/**
	 * mergeRafProcessInstance - merges a RafProcessInstance
	 * 
	 * @param rafProcessInstance
	 * @return the merged RafProcessInstance
	 */
	public RafProcessInstance mergeRafProcessInstance(RafProcessInstance rafProcessInstance);

	/**
	 * mergeRafProcessInstanceList - merges a list of RafProcessInstance
	 * 
	 * @param rafProcessInstanceList
	 * @return the merged list of RafProcessInstance
	 */
	public ArrayList<RafProcessInstance> mergeRafProcessInstanceList(
			List<RafProcessInstance> rafProcessInstanceList);

	/**
	 * removeRafProcessInstance - removes a RafProcessInstance
	 * 
	 * @param rafProcessInstance
	 */
	public void removeRafProcessInstance(RafProcessInstance rafProcessInstance);

	/**
	 * removeRafProcessInstanceList - removes a list of RafProcessInstance
	 * 
	 * @param rafProcessInstanceList
	 */
	public void removeRafProcessInstanceList(List<RafProcessInstance> rafProcessInstanceList);

	/**
	 * findByRafProcessInstanceLike - finds a list of RafProcessInstance Like
	 * 
	 * @param rafProcessInstance
	 * @return the list of RafProcessInstance found
	 */
	public List<RafProcessInstance> findByRafProcessInstanceLike(RafProcessInstance rafProcessInstance,
			JPQLAdvancedQueryCriteria criteria, int firstResult, int maxResults);
			
	/**
	 * findByRafProcessInstance>LikeFR - finds a list of RafProcessInstance> Like with a finder return object
	 * 
	 * @param rafProcessInstance
	 * @return the list of RafProcessInstance found
	 */
	public FinderReturn findByRafProcessInstanceLikeFR(RafProcessInstance rafProcessInstance,
			JPQLAdvancedQueryCriteria criteria, int firstResult, int maxResults);
}
