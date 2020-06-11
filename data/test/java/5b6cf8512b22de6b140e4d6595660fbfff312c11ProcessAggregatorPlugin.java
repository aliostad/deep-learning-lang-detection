package io.analytica.server.aggregator;

import java.util.List;
import java.util.Map;

import io.analytica.api.KProcess;
import io.analytica.server.store.Identified;
import io.vertigo.lang.Plugin;


public interface ProcessAggregatorPlugin extends Plugin {

	/**
	 * Add a process.
	 * @param process Process to push
	 * @throws ProcessAggregatorException 
	 */	
	void push(Identified<KProcess> process) throws ProcessAggregatorException;

	String getLastInsertedProcess(final ProcessAggregatorQuery aggregatorQuery);
	
	List<ProcessAggregatorDto> findAllLocations(final ProcessAggregatorQuery aggregatorQuery) throws ProcessAggregatorException;
	
	List<ProcessAggregatorDto> findAllTypes(final ProcessAggregatorQuery aggregatorQuery) throws ProcessAggregatorException;

	List<ProcessAggregatorDto> findAllCategories(final ProcessAggregatorQuery aggregatorQuery)throws ProcessAggregatorException;

	List<ProcessAggregatorDto> findCategories(final ProcessAggregatorQuery aggregatorQuery)throws ProcessAggregatorException;

	List<ProcessAggregatorDto> getTimeLine(final ProcessAggregatorQuery aggregatorQuery)throws ProcessAggregatorException;

	
}
