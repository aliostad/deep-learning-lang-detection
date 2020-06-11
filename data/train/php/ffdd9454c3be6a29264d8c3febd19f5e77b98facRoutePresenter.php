<?php

namespace NewsletterModule\Pages\Newsletter;

use BlogModule\Pages\Blog\AbstractRoutePresenter;
use Nette\Application\BadRequestException;

class RoutePresenter extends AbstractRoutePresenter
{

	/** @persistent */
	public $key;

	/** @var NewsletterRepository */
	private $repository;

	/** @var UserRepository */
	private $userRepository;


	/**
	 * @param NewsletterRepository $repository
	 * @param UserRepository $userRepository
	 */
	public function inject(
		NewsletterRepository $repository,
		UserRepository $userRepository
	)
	{
		$this->repository = $repository;
		$this->userRepository = $userRepository;
	}


	protected function startup()
	{
		parent::startup();

		if ($this->key) {
			if (($user = $this->userRepository->findOneBy(array('userKey' => $this->key))) === NULL) {
				throw new BadRequestException;
			}

			$this->userRepository->delete($user);
			$this->flashMessage('Byl jste odhlášen z newsletteru.', 'success');
			$this->redirect('this', array('key' => NULL));
		}
	}


	/**
	 * @return NewsletterRepository
	 */
	protected function getRepository()
	{
		return $this->repository;
	}


	public function handleLogout()
	{
		$this->flashMessage('Byl jste odhlášen z oběru novinek', 'success');
		$this->redirect('this');
	}

}