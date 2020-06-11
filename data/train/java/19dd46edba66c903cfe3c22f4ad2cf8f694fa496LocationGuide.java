package domain;

import db.Repository;
import db.RepositoryFactory;
import java.util.List;

public class LocationGuide {
    private Repository repository;
    
    public LocationGuide(String type) {
        RepositoryFactory rf = new RepositoryFactory();
        repository = rf.createRepository(type);
    }
    
    public Location getLocation(int id) {
        return this.repository.getLocation(id);
    }
    
    public List<Location> getLocations() {
        return this.repository.getLocations();
    }
}
