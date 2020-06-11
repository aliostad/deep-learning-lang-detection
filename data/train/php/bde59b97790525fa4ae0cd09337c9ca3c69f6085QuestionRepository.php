<?php namespace MPP\Repository\Question;

use MPP\Repository\Crudable;
use MPP\Repository\Panigable;
use MPP\Repository\Repository;

/**
 * Interface QuestionRepository
 *
 * @package MPP\Repository\Question
 */
interface QuestionRepository extends Repository, Crudable, Panigable
{
   /**
    * Get latest added questions.
    *
    * @param array $with
    * @param $orderByColumn
    * @param $orderByDirection
    * @param $number
    * @return mixed
    */
   public function getLatestQuestions(array $with, $orderByColumn, $orderByDirection, $number);
}
