package se.likfarmenhet.garage.repository;

import java.util.List;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import se.likfarmenhet.garage.model.Vehicle;

/**
 *
 * @author Alexander
 */
@Repository
public interface VehicleRepository extends CrudRepository<Vehicle, Integer> {

    public Vehicle findByLicensePlate(String licensePlate);

}
