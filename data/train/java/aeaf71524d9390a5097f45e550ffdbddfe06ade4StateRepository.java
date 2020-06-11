package com.rv.tour.repository;

import com.rv.tour.domain.City;
import com.rv.tour.domain.State;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;

@Transactional
@Repository
public interface StateRepository extends JpaRepository<State, Long>, PagingAndSortingRepository<State, Long> {
    List<State> findStateByAbbreviation(String abbreviation);
}
