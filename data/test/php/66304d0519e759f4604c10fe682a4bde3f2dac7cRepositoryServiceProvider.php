<?php namespace MPP\Repository;

use Illuminate\Support\ServiceProvider;
use MPP\Cache\Cache;
use MPP\Cache\Answer\AnswerCacheDecorator;
use MPP\Repository\Answer\EloquentAnswerRepository;
use MPP\Cache\Question\QuestionCacheDecorator;
use MPP\Repository\Question\EloquentQuestionRepository;
use MPP\Repository\Register\EloquentRegisterRepository;
use MPP\Repository\Session\EloquentSessionRepository;
use MPP\Repository\Tag\EloquentTagRepository;
use MPP\Repository\User\EloquentUserRepository;
use User;
use Question;
use Answer;
use Sentry;
use Tag;

/**
 * Class RepositoryServiceProvider
 *
 * @package MPP\Repository
 */
class RepositoryServiceProvider extends ServiceProvider
{
   /**
    * Register repositories.
    */
   public function register()
   {
      $this->registerSessionRepository();
      $this->registerRegisterRepository();
      $this->registerUserRepository();
      $this->registerQuestionRepository();
      $this->registerAnswerRepository();
      $this->registerTagRepository();
   }

   /**
    * Register session repository.
    */
   protected function registerSessionRepository()
   {
      $this->app->bind('MPP\Repository\Session\SessionRepository', function($app) {
         return new EloquentSessionRepository();
      });
   }

   /**
    * Register register repository.
    */
   protected function registerRegisterRepository()
   {
      $this->app->bind('MPP\Repository\Register\RegisterRepository', function($app) {
         return new EloquentRegisterRepository(new Sentry());
      });
   }

   /**
    * Register user repository.
    */
   protected function registerUserRepository()
   {
      $this->app->bind('MPP\Repository\User\UserRepository', function($app) {
         return new EloquentUserRepository(new User());
      });
   }

   /**
    * Register question repository.
    */
   protected function registerQuestionRepository()
   {
      $this->app->bind('MPP\Repository\Question\QuestionRepository', function($app) {
         $questionRepository =  new EloquentQuestionRepository(
            new Question(),
            $app->make('MPP\Repository\Tag\TagRepository')
         );

         /* Uncomment to use cache for questions.

         return new QuestionCacheDecorator(
            $questionRepository,
            new Cache($app['cache'], 'question'),
            new Question()
         );*/
         return $questionRepository;
      });
   }

   /**
    * Register answer repository.
    */
   protected function registerAnswerRepository()
   {
      $this->app->bind('MPP\Repository\Answer\AnswerRepository', function($app) {
         $answerRepository = new EloquentAnswerRepository(new Answer());

         /* Uncomment to use cache for answers.

         return new AnswerCacheDecorator(
            $answerRepository,
            new Cache($app['cache'], 'answer'),
            new Answer()
         );*/
         return $answerRepository;
      });
   }

   /**
    * Register tag repository.
    */
   protected function registerTagRepository()
   {
      $this->app->bind('MPP\Repository\Tag\TagRepository', function($app) {
         return new EloquentTagRepository(new Tag(), new Question());
      });
   }
}