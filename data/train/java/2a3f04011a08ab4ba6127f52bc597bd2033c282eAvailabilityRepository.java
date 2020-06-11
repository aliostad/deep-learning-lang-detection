package com.lsdt.LittleSproutsScheduler.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.lsdt.LittleSproutsScheduler.model.Availability;

@Repository("availabilityRepository")
public interface AvailabilityRepository extends JpaRepository<Availability, Long> {

	@Query("select a from Availability a")
	List<Availability> getAllAvailabilities();

}
