package org.project.persistence.service.impl;

import org.project.persistence.repository.EventRepository;
import org.project.persistence.service.EventRepositoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EventRepositoryServiceImpl implements EventRepositoryService {
    @Autowired
    private EventRepository eventRepository;

    @Override
    public EventRepository getEventRepository() {
        return eventRepository;
    }
}
