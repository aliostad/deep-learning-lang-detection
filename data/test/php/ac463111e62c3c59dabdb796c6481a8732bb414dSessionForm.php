<?php namespace MPP\Form\Session;

use MPP\Form\AbstractForm;
use MPP\Repository\Session\SessionRepository;
use MPP\Validation\ValidationInterface;

/**
 * Class SessionForm
 *
 * @package MPP\Form\Session
 */
class SessionForm extends AbstractForm
{
   /**
    * Constructor.
    *
    * @param SessionRepository $sessionRepository
    * @param ValidationInterface $validationInterface
    */
   public function __construct(
      SessionRepository   $sessionRepository,
      ValidationInterface $validationInterface
   )
   {
      $this->repository = $sessionRepository;
      $this->validator  = $validationInterface;
   }
}