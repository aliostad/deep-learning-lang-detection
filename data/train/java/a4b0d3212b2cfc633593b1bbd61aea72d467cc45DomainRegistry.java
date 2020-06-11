package org.taxidermia.voteweekrestaurant.model;

/**
 * Registra las entidades de Dominio
 */
public class DomainRegistry {

    private VoteRepository voteRepository;
    private PersonRepository personRepository;
    private RestaurantRepository restaurantRepository;



    public DomainRegistry() {

        this.personRepository = new MemoryPersonRepository();
        this.voteRepository = new MemoryVoteRepository();
        this.restaurantRepository = new MemoryRestaurantRepository();

    }

    public VoteRepository voteRepository() {
        return this.voteRepository;
    }

    public PersonRepository personRepository() {
        return this.personRepository;
    }

    public RestaurantRepository restaurantRepository() {
        return this.restaurantRepository;
    }

}
