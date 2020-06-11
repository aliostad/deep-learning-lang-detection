package com.epam.spring.advanced.homework.repository;

import com.epam.spring.advanced.homework.domain.Ticket;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import java.util.Collection;

@Repository
@Qualifier("ticketRepository")
public class TicketRepositoryImpl extends MapBasedIdentityRepository<Ticket> implements TicketRepository {

    public TicketRepositoryImpl() {
    }

    public TicketRepositoryImpl(Collection<Ticket> tickets) {
        super(tickets);
    }
}
