package ci.smile.oci.openapi.dao.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ci.smile.oci.openapi.dao.entity.SubscriptionEntity;


@Repository
public interface SubscriptionRepository extends JpaRepository<SubscriptionEntity, Integer>{

    @Query(""
        + " ") 
    SubscriptionEntity findById(  @Param("id") Integer id);
    

    


}
