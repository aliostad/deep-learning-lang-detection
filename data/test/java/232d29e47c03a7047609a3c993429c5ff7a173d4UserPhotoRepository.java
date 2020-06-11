package com.bywires.transrepo.fixtures;

public class UserPhotoRepository implements IUserPhotoRepository
{
    private IUserRepository userRepository;
    private IPhotoRepository photoRepository;

    public UserPhotoRepository(IUserRepository userRepository, IPhotoRepository photoRepository)
    {
        this.userRepository = userRepository;
        this.photoRepository = photoRepository;
    }

    public IUserRepository getUserRepository()
    {
        return userRepository;
    }

    public IPhotoRepository getPhotoRepository()
    {
        return photoRepository;
    }
}
