package services;

import java.util.Collection;
import java.util.List;

import models.Stadium;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import repository.StadiumRepository;
import repository.StadiumRepository.BlockCount;
import repository.TicketRepository;

/**
 * 
 * @author Mark Wigmans
 * 
 */
@Service
public class StadiumService {

    private final StadiumRepository stadiumRepository;
    private final TicketRepository ticketRepository;

    @Autowired
    public StadiumService(final StadiumRepository repository, TicketRepository ticketRepository) {
        super();
        this.stadiumRepository = repository;
        this.ticketRepository = ticketRepository;
    }

    public void reset() {
        stadiumRepository.reset();
        ticketRepository.reset();
    }

    public Collection<Stadium> getAll() {
        return stadiumRepository.getAll();
    }

    public Stadium get(final String id) {
        return stadiumRepository.get(id);
    }

    public void add(final Stadium stadium) {
        stadiumRepository.add(stadium);
    }

    public List<BlockCount> available(final String id) {
        return stadiumRepository.available(id);
    }
}