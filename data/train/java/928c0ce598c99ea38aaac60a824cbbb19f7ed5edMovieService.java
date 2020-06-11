package com.mycompany.movies.service;

import com.mycompany.movies.repository.MovieRepository;
import com.mycompany.movies.repository.UserRepository;
import javax.ejb.EJB;
import javax.ejb.Stateless;

@Stateless
public class MovieService {
    @EJB
    private MovieRepository repositoryMovie;
    private UserRepository repositoryUser; 

    public MovieRepository getRepositoryMovie() {
        return repositoryMovie;
    }

    public UserRepository getRepositoryUser() {
        return repositoryUser;
    }
    
}
