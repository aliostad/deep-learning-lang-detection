package com.swg.base.backend.repository;

import com.swg.base.backend.entity.VoteResult;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

/**
 * Repository data hasil perhitungan perolehan suara.
 *
 * @author zakyalvan
 */
@Repository
public interface VoteResultRepository extends
        JpaRepository<VoteResult, Integer>,
        JpaSpecificationExecutor<VoteResult> {

}
