package de.endios.vertragswechsel.repository;

import java.util.List;



import org.springframework.data.jpa.repository.JpaRepository;

import de.endios.vertragswechsel.domain.ProcessTariff;

/**
 * The Interface TariffRepository.
 * @author  Endios (lawrencewamala)
 * @version 1.0
 * @since   2016-08-04<br>
 *  <p>
 */


public interface ProcessTariffRepository extends JpaRepository <ProcessTariff, Long> {

	/**
	 * Find by process id.
	 *
	 * @param processId - the busness process id
	 * @return Tariff list
	 */
	List<ProcessTariff> findByProcessId(String processId);
	
	/**
	 * Find by process id and id.
	 *
	 * @param processId - the process id
	 * @param id - the id
	 * @return the tariff
	 */
	ProcessTariff findByProcessIdAndId(String processId, long id);


}