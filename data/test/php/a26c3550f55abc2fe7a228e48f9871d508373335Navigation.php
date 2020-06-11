<?php

namespace App\ForumModule\Controls;

use Nette\Application\UI\Control;
use App\Model\Facades\Forum\Controls\NavigationFacade;

class Navigation extends Control
{
	private $forumId = NULL;

	private $topicId = NULL;

	private $facade;

	/**
	 * @param \App\Model\Facades\Forum\Controls\NavigationFacade $facade
	 */
	public function __construct(NavigationFacade $facade)
	{
		parent::__construct();
		$this->facade = $facade;
	}

	/**
	 * @param int|NULL $id forum id
	 */
	public function setForumId($id = NULL)
	{
		$this->forumId = $id;
	}

	/**
	 * @param int|NULL $id topic id
	 */
	public function setTopicId($id = NULL)
	{
		$this->topicId = $id;
	}

	public function render()
	{
		$this->template->setFile(__DIR__ . '/Navigation.latte');
		$this->template->location = $this->facade->getLocation($this->forumId, $this->topicId);
		$this->template->render();
	}
}
