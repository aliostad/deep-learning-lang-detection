package ru.trendtech.repositories;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;
import ru.trendtech.domain.Tablet;

/**
 * Created by petr on 22.06.2015.
 */
@Repository
public interface TabletRepository extends PagingAndSortingRepository<Tablet, Long> {
     @Query("select count(t) from Tablet t")
     int countTablets();
}
