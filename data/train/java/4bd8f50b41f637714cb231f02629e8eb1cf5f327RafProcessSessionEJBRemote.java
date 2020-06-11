package com.gdn.venice.facade;

import java.util.ArrayList;
import java.util.List;

import javax.ejb.Remote;

import com.gdn.venice.persistence.RafProcess;
import com.djarum.raf.utilities.JPQLAdvancedQueryCriteria;
import com.gdn.venice.facade.finder.FinderReturn;

@Remote
public interface RafProcessSessionEJBRemote {

	/**
	 * queryByRange - allows querying by range/block
	 * 
	 * @param jpqlStmt
	 * @param firstResult
	 * @param maxResults
	 * @return a list of RafProcess
	 */
	public List<RafProcess> queryByRange(String jpqlStmt, int firstResult,
			int maxResults);

	/**
	 * persistRafProcess persists a country
	 * 
	 * @param rafProcess
	 * @return the persisted RafProcess
	 */
	public RafProcess persistRafProcess(RafProcess rafProcess);

	/**
	 * persistRafProcessList - persists a list of RafProcess
	 * 
	 * @param rafProcessList
	 * @return the list of persisted RafProcess
	 */
	public ArrayList<RafProcess> persistRafProcessList(
			List<RafProcess> rafProcessList);

	/**
	 * mergeRafProcess - merges a RafProcess
	 * 
	 * @param rafProcess
	 * @return the merged RafProcess
	 */
	public RafProcess mergeRafProcess(RafProcess rafProcess);

	/**
	 * mergeRafProcessList - merges a list of RafProcess
	 * 
	 * @param rafProcessList
	 * @return the merged list of RafProcess
	 */
	public ArrayList<RafProcess> mergeRafProcessList(
			List<RafProcess> rafProcessList);

	/**
	 * removeRafProcess - removes a RafProcess
	 * 
	 * @param rafProcess
	 */
	public void removeRafProcess(RafProcess rafProcess);

	/**
	 * removeRafProcessList - removes a list of RafProcess
	 * 
	 * @param rafProcessList
	 */
	public void removeRafProcessList(List<RafProcess> rafProcessList);

	/**
	 * findByRafProcessLike - finds a list of RafProcess Like
	 * 
	 * @param rafProcess
	 * @return the list of RafProcess found
	 */
	public List<RafProcess> findByRafProcessLike(RafProcess rafProcess,
			JPQLAdvancedQueryCriteria criteria, int firstResult, int maxResults);
			
	/**
	 * findByRafProcess>LikeFR - finds a list of RafProcess> Like with a finder return object
	 * 
	 * @param rafProcess
	 * @return the list of RafProcess found
	 */
	public FinderReturn findByRafProcessLikeFR(RafProcess rafProcess,
			JPQLAdvancedQueryCriteria criteria, int firstResult, int maxResults);
}
