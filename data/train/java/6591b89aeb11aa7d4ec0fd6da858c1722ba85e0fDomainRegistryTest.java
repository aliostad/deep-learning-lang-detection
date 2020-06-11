package org.taxidermia.voteweekrestaurant.model;

import org.junit.Test;

import static org.junit.Assert.assertNotNull;

public class DomainRegistryTest {


    @Test
    public void testDomainRegistryPersonRepositoryInit(){
        DomainRegistry domainRegistry = new DomainRegistry();
        PersonRepository personRepository = domainRegistry.personRepository();
        assertNotNull(personRepository);

    }

    @Test
    public void testDomainRegistryVoteRepositoryInit(){
        DomainRegistry domainRegistry = new DomainRegistry();
        VoteRepository voteRepository = domainRegistry.voteRepository();
        assertNotNull(voteRepository);

    }

    @Test
    public void testDomainRegistryRestaurantRepositoryInit(){
        DomainRegistry domainRegistry = new DomainRegistry();
        RestaurantRepository restaurantRepository = domainRegistry.restaurantRepository();
        assertNotNull(restaurantRepository);

    }
}
