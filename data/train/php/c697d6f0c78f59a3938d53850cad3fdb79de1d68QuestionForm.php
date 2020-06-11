<?php namespace MPP\Form\Question;

use MPP\Form\AbstractForm;
use MPP\Repository\Question\QuestionRepository;
use MPP\Validation\ValidationInterface;

/**
 * Class QuestionForm
 *
 * @package MPP\Form\Question
 */
class QuestionForm extends AbstractForm
{
   /**
    * Constructor.
    *
    * @param QuestionRepository $questionRepository
    * @param ValidationInterface $validationInterface
    */
   public function __construct(
      QuestionRepository  $questionRepository,
      ValidationInterface $validationInterface
   )
   {
      $this->repository = $questionRepository;
      $this->validator  = $validationInterface;
   }
}
