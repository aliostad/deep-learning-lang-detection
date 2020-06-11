package com.butter.process;

import java.util.Collection;




/**
* Data access object used to access cfms process and errors. This class contains simple crud
* based functions to manipulate the data.
*/
public interface ButterProcessDao {
  
  /**
   * @param processId
   * @return Collection of ProcessError's
   */
  public Collection<ButterProcessError> getErrors(String processId);
  
  /**
   * @param errorId
   * @return ProcessError
   */
  public ButterProcessError getError(String errorId);
  
  
  /**
	 * Insert a process onto the system
	 * @param process to insert
	 */
	public void insertProcess(ButterProcess ButterProcess);
	
	/**
	 * Update a process on the system
	 * @param  process to insert
	 */
	public void updateProcess(ButterProcess ButterProcess);
	
  /**
   * @param processId
   * @return ButterProcess
   */
  public ButterProcess getProcess(String processId);
  
	/**
   * Retrieve a collection of processes
   * @param  criteria
   * @return A collection of ButterProcess objects
   */
  public Collection<ButterProcess> processSearch(ButterProcessCriteria processCriterai);
}
