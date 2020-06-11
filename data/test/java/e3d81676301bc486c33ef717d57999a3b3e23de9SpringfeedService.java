package com.springapp.mvc.services;

import com.springapp.mvc.repository.*;
import com.springapp.mvc.security.SecurityContextAccessor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by Ryan on 13/03/2015.
 */
@Service
@Transactional
public class SpringfeedService {

    private FeedRepository feedRepository;
    private FollowRepository followRepository;
    private TweetRepository tweetRepository;
    private UserRepository userRepository;
    private TagRepository tagRepository;
    private RetweetRepository retweetRepository;
    private FavouriteRepository favouriteRepository;
    private PrivateMessageRepository privateMessageRepository;
    private NotificationRepository notificationRepository;
    private SecurityContextAccessor securityContextAccessor;

    public TweetRepository getTweetRepository() {
        return tweetRepository;
    }

    @Autowired
    public void setTweetRepository(TweetRepository tweetRepository) {
        this.tweetRepository = tweetRepository;
    }

    public UserRepository getUserRepository() {
        return userRepository;
    }

    @Autowired
    public void setUserRepository(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public SecurityContextAccessor getSecurityContextAccessor() {
        return securityContextAccessor;
    }

    @Autowired
    public void setSecurityContextAccessor(SecurityContextAccessor securityContextAccessor) {
        this.securityContextAccessor = securityContextAccessor;
    }

    public FollowRepository getFollowRepository() {
        return followRepository;
    }

    @Autowired
    public void setFollowRepository(FollowRepository followRepository) {
        this.followRepository = followRepository;
    }

    public TagRepository getTagRepository() {
        return tagRepository;
    }

    @Autowired
    public void setTagRepository(TagRepository tagRepository) {
        this.tagRepository = tagRepository;
    }

    public PrivateMessageRepository getPrivateMessageRepository() {
        return privateMessageRepository;
    }

    @Autowired
    public void setPrivateMessageRepository(PrivateMessageRepository privateMessageRepository) {
        this.privateMessageRepository = privateMessageRepository;
    }

    public NotificationRepository getNotificationRepository() {
        return notificationRepository;
    }

    @Autowired
    public void setNotificationRepository(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    public RetweetRepository getRetweetRepository() {
        return retweetRepository;
    }

    @Autowired
    public void setRetweetRepository(RetweetRepository retweetRepository) {
        this.retweetRepository = retweetRepository;
    }

    public FavouriteRepository getFavouriteRepository() {
        return favouriteRepository;
    }

    @Autowired
    public void setFavouriteRepository(FavouriteRepository favouriteRepository) {
        this.favouriteRepository = favouriteRepository;
    }

    public FeedRepository getFeedRepository() {
        return feedRepository;
    }

    @Autowired
    public void setFeedRepository(FeedRepository feedRepository) {
        this.feedRepository = feedRepository;
    }
}
