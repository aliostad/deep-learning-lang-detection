package org.opendarts.ui.stats.service;

import org.opendarts.core.stats.service.IStatsService;

/**
 * The Interface IStatsUiProvider.
 */
public interface IStatsUiProvider {

	/**
	 * Register stats ui service.
	 *
	 * @param statsService the stats service
	 * @param statsUiService the stats ui service
	 */
	void registerStatsUiService(IStatsService statsService,
			IStatsUiService statsUiService);

	/**
	 * Gets the stats ui service.
	 *
	 * @param statsService the stats service
	 * @return the stats ui service
	 */
	IStatsUiService getStatsUiService(IStatsService statsService);

	/**
	 * Unregister stats ui service.
	 *
	 * @param statsService the stats service
	 */
	void unregisterStatsUiService(IStatsService statsService);

}
