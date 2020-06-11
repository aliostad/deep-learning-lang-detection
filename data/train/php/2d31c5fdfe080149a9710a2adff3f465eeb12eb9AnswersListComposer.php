<?php namespace MPP\Composer;

use MPP\Repository\Answer\AnswerRepository;

/**
 * Class AnswersListComposer
 *
 * @package MPP\Composer
 */
class AnswersListComposer
{
   /**
    * Answer repository.
    *
    * @var \MPP\Repository\Answer\AnswerRepository
    */
   protected $answerRepository;

   /**
    * Constructor.
    *
    * @param AnswerRepository $answerRepository
    */
   public function __construct(AnswerRepository $answerRepository)
   {
      $this->answerRepository = $answerRepository;
   }

   /**
    * Compose.
    *
    * @param $view
    */
   public function compose($view)
   {
      $recentAnswers = $this->answerRepository->getLatestAnswers(array('questions'), 'id', 'desc', 10);
      $view->with('recentAnswers', $recentAnswers);
   }
}