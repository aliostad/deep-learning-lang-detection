package com.fave100.client.generated.services;

import com.google.inject.Inject;

public class RestServiceFactory {

    private AuthService _authService;
    private FavelistsService _favelistsService;
    private SearchService _searchService;
    private SongsService _songsService;
    private TrendingService _trendingService;
    private UserService _userService;
    private UsersService _usersService;
    
    @Inject
    public RestServiceFactory(AuthService authService, FavelistsService favelistsService, SearchService searchService, SongsService songsService, TrendingService trendingService, UserService userService, UsersService usersService) {
         _authService = authService;
         _favelistsService = favelistsService;
         _searchService = searchService;
         _songsService = songsService;
         _trendingService = trendingService;
         _userService = userService;
         _usersService = usersService;
        }

    public AuthService auth() {
        return _authService;
    }

    public FavelistsService favelists() {
        return _favelistsService;
    }

    public SearchService search() {
        return _searchService;
    }

    public SongsService songs() {
        return _songsService;
    }

    public TrendingService trending() {
        return _trendingService;
    }

    public UserService user() {
        return _userService;
    }

    public UsersService users() {
        return _usersService;
    }

}