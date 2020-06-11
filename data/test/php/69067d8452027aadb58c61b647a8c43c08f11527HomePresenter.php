<?php

namespace FrontendModule;
use \Nette\Application\UI;

class HomePresenter extends BasePresenter {

	/** @var \PostsRepository */
	private $postsRepository;

	/** @var \CommentsRepository */
	private $commentsRepository;

	public function __construct(\PostsRepository $postsRepository, \CommentsRepository $commentsRepository) {
		$this->postsRepository = $postsRepository;
		$this->commentsRepository = $commentsRepository;
	}

	public function renderDefault() {
		$this->template->posts = $this->postsRepository->fetchAll();
	}
}