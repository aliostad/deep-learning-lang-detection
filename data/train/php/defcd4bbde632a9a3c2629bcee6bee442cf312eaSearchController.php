<?php

namespace App\Controllers;

use App\Controllers\Base\SearchBaseController;
use App\Repositories\CommunityRepository;
use App\Repositories\HashtagRepository;
use App\Repositories\EventRepository;
use App\Repositories\PostRepository;
use App\Repositories\UserRepository;

/* Adam Endvy */
class SearchController extends SearchBaseController
{
    public function __construct(
        PostRepository $postRepository,
        HashtagRepository $hashtagRepository,
        CommunityRepository $communityRepository,
        EventRepository $eventRepository
    )
    {
        parent::__construct();
        $this->postRepository = $postRepository;
        $this->hashtagRepository = $hashtagRepository;
        $this->communityRepository = $communityRepository;
        $this->eventRepository = $eventRepository;

        $this->setTitle(trans('search.search'));
    }

    public function index()
    {
        return $this->render('search.people', ['users' => $this->userRepository->search($this->searchRepository->term)]);
    }

    public function hashtag()
    {
        $this->setType('hashtag');

        return $this->render('search.hashtag', [
            'posts' => $this->postRepository->search('#'.$this->searchRepository->term),
            'hashtags' => $this->hashtagRepository->trending(10)
        ]);
    }
    public function posts()
    {
        $this->setType('posts');

        return $this->render('search.posts', ['posts' => $this->postRepository->search($this->searchRepository->term)]);

    }

    public function communities()
    {
        $this->setType('communities');

        return $this->render('search.communities', ['communities' => $this->communityRepository->search($this->searchRepository->term)]);
    }

    public function events()
    {
        $this->setType('events');
        return $this->render('search.events', ['events' => $this->eventRepository->search($this->searchRepository->term)]);
    }

    public function dropdown()
    {
        $hashtags = [];

        $events = $this->eventRepository->search($this->searchRepository->term, 3);
        $communities = $this->communityRepository->search($this->searchRepository->term, 3);

        $hashtags = $this->hashtagRepository->search($this->searchRepository->term, 5);

        return $this->theme->section('search.dropdown', [
            'users' => $this->userRepository->search($this->searchRepository->term, 3),
            'hashtags' => $hashtags,
            'events' => $events,
            'communities' => $communities
        ]);
    }
}