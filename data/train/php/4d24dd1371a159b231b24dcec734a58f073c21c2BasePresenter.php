<?php

use Nette\Application\UI\Form;



/**
 * Base presenter for all application presenters.
 *
 * @property callable $newListFormSubmitted
 */
abstract class BasePresenter extends Nette\Application\UI\Presenter
{

        /** @var Todo\ListRepository */
        protected $objednavkaRepository;
		protected $pacientRepository;
		protected $jidlaRepository;
		protected $surovinyRepository;
		protected $userRepository;
		protected $rolesRepository;
		protected $stavRepository;
		protected $aktivitaRepository;
		
		

 public function injectBase(Todo\Objednavka_Na_KuchynRepository $objednavkaRepository,Todo\PacientRepository $pacientRepository,Todo\JidloRepository $jidlaRepository,Todo\SurovinyRepository $surovinyRepository,Todo\UserRepository $userRepository,Todo\RolesRepository $rolesRepository,Todo\StavRepository $stavRepository,Todo\AktivitaRepository $aktivitaRepository)
        {
                $this->objednavkaRepository = $objednavkaRepository;
				$this->pacientRepository = $pacientRepository;
				$this->jidlaRepository = $jidlaRepository;
				$this->surovinyRepository = $surovinyRepository;
				$this->userRepository = $userRepository;
				$this->rolesRepository = $rolesRepository;
				$this->stavRepository = $stavRepository;
				$this->aktivitaRepository = $aktivitaRepository;
        }



        public function beforeRender()
        {
                $this->template->lists = $this->objednavkaRepository->findConfirmed()->order('title ASC');
        }



        /**s
         * @return Nette\Application\UI\Form
         */
        		public function handleSignOut()
{
    $this->getUser()->logout();
    $this->redirect('Sign:in');
}

}