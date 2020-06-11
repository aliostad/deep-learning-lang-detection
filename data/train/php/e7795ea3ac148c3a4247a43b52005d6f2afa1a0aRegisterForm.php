<?php namespace MPP\Form\Register;

use MPP\Form\AbstractForm;
use MPP\Repository\Register\RegisterRepository;
use MPP\Validation\ValidationInterface;

/**
 * Class RegisterForm
 *
 * @package MPP\Form\Register
 */
class RegisterForm extends AbstractForm
{
   /**
    * Constructor.
    *
    * @param RegisterRepository $registerRepository
    * @param ValidationInterface $validationInterface
    */
   public function __construct(
      RegisterRepository  $registerRepository,
      ValidationInterface $validationInterface
   )
   {
      $this->repository = $registerRepository;
      $this->validator  = $validationInterface;
   }
}
