<?php

namespace App\Providers;

use App\Core\Bussiness\AnswerRepository;
use App\Core\Bussiness\AssignmentRepository;
use App\Core\Bussiness\CourseAssignmentRepository;
use App\Core\Bussiness\CourseCategoryRepository;
use App\Core\Bussiness\CourseQuizRepository;
use App\Core\Bussiness\CourseRepository;
use App\Core\Bussiness\CourseUnitRepository;
use App\Core\Bussiness\EnrollCourseRepository;
use App\Core\Bussiness\QuestionRepository;
use App\Core\Bussiness\QuizQuestionRepository;
use App\Core\Bussiness\QuizRepository;
use App\Core\Bussiness\UnitRepository;
use App\Core\Bussiness\UserAnswerRepository;
use App\Core\Repository\AnswerRepositoryInterface;
use App\Core\Repository\AssignmentRepositoryInterface;
use App\Core\Repository\CourseAssignmentRepositoryInterface;
use App\Core\Repository\CourseCategoryRepositoryInterface;
use App\Core\Repository\CourseQuizRepositoryInterface;
use App\Core\Repository\CourseRepositoryInterface;
use App\Core\Repository\CourseUnitRepositoryInterface;
use App\Core\Repository\EnrollCourseRepositoryInterface;
use App\Core\Repository\QuestionRepositoryInterface;
use App\Core\Repository\QuizQuestionRepositoryInterface;
use App\Core\Repository\QuizRepositoryInterface;
use App\Core\Repository\UnitRepositoryInterface;
use App\Core\Repository\UserAnswerRepositoryInterface;
use Illuminate\Support\ServiceProvider;
use App\Core\Repository\UserRepositoryInterface;
use App\Core\Bussiness\UserRepository;
class AppServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        //
    }

    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        $this->app->bind(UserRepositoryInterface::class,function($app) {
            return new UserRepository($app);
        });

        $this->app->bind(CourseRepositoryInterface::class,function($app) {
            return new CourseRepository($app);
        });

        $this->app->bind(UnitRepositoryInterface::class,function($app) {
            return new UnitRepository($app);
        });
        
        $this->app->bind(EnrollCourseRepositoryInterface::class,function($app) {
            return new EnrollCourseRepository($app);
        });

        $this->app->bind(QuizRepositoryInterface::class,function($app) {
            return new QuizRepository($app);
        });

        $this->app->bind(QuestionRepositoryInterface::class,function($app) {
            return new QuestionRepository($app);
        });

        $this->app->bind(QuizQuestionRepositoryInterface::class,function($app) {
            return new QuizQuestionRepository($app);
        });
        $this->app->bind(AnswerRepositoryInterface::class,function($app) {
            return new AnswerRepository($app);
        });

        $this->app->bind(AssignmentRepositoryInterface::class,function($app) {
            return new AssignmentRepository($app);
        });

        $this->app->bind(CourseCategoryRepositoryInterface::class,function($app) {
            return new CourseCategoryRepository($app);
        });

        $this->app->bind(CourseUnitRepositoryInterface::class,function($app) {
            return new CourseUnitRepository($app);
        });

        $this->app->bind(CourseQuizRepositoryInterface::class,function($app) {
            return new CourseQuizRepository($app);
        });

        $this->app->bind(CourseAssignmentRepositoryInterface::class,function($app) {
            return new CourseAssignmentRepository($app);
        });

        $this->app->bind(UserAnswerRepositoryInterface::class,function($app) {
            return new UserAnswerRepository($app);
        });
    }
}
