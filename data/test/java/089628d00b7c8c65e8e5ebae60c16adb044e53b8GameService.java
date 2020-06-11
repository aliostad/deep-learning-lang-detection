package de.olivelo.gamesearch.mvc;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GameService {

    private SolrGameRepository repository;

    public void addGame(Game game) {
        repository.save(game);
    }

    public Iterable<Game> getAllGames() {
        return repository.findAll();
    }

    @Autowired
    public void setRepository(final SolrGameRepository repository) {
        this.repository = repository;
    }

}
