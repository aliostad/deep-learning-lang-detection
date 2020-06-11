<?php namespace MPP\Composer;

use MPP\Repository\Question\QuestionRepository;

/**
 * Class QuestionsListComposer
 *
 * @package MPP\Composer
 */
class QuestionsListComposer
{
   /**
    * Question repository.
    *
    * @var \MPP\Repository\Question\QuestionRepository
    */
   protected $questionRepository;

   /**
    * Constructor.
    *
    * @param QuestionRepository $questionRepository
    */
   public function __construct(QuestionRepository $questionRepository)
   {
      $this->questionRepository = $questionRepository;
   }

   /**
    * Compose.
    *
    * @param $view
    */
   public function compose($view)
   {
      $recentQuestions = $this->questionRepository->getLatestQuestions(array('users', 'answers', 'tags', 'votes'), 'id', 'desc', 10);
      $view->with('recentQuestions', $recentQuestions);
   }
}