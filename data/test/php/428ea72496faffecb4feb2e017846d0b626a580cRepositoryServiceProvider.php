<?php namespace Trackr\Repository;

use User, UserProfile;
use Department;
use Job;
use Project;
use Attendance;
use Announcement;
use Task;

use Trackr\Repository\Users\EloquentUsersRepository;
use Trackr\Repository\Departments\EloquentDepartmentsRepository;
use Trackr\Repository\Jobs\EloquentJobsRepository;
use Trackr\Repository\Projects\EloquentProjectsRepository;
use Trackr\Repository\Attendances\EloquentAttendancesRepository;
use Trackr\Repository\Announcements\EloquentAnnouncementsRepository;
use Trackr\Repository\Tasks\EloquentTasksRepository;

use Illuminate\Support\ServiceProvider;

class RepositoryServiceProvider extends ServiceProvider
{

  /**
   * Register the repositories
   *
   * @return void
   */

  public function register()
  {
    $app = $this->app;

    //Users Repository
    $app->bind(
      'Trackr\Repository\Users\InterfaceUsersRepository',
    function(){
        return new EloquentUsersRepository(new User, new UserProfile);
    });

    //Departments Repository
    $app->bind(
      'Trackr\Repository\Departments\InterfaceDepartmentsRepository',
    function(){
        return new EloquentDepartmentsRepository(new Department);
    });

    //Jobs Repository
    $app->bind(
      'Trackr\Repository\Jobs\InterfaceJobsRepository',
    function(){
        return new EloquentJobsRepository(new Job);
    });

    //Projects Repository
    $app->bind(
      'Trackr\Repository\Projects\InterfaceProjectsRepository',
    function(){
        return new EloquentProjectsRepository(new Project);
    });

    //Attendances Repository
    $app->bind(
      'Trackr\Repository\Attendances\InterfaceAttendancesRepository',
    function(){
        return new EloquentAttendancesRepository(new Attendance);
    });

    //Announcement Repository
    $app->bind(
      'Trackr\Repository\Announcements\InterfaceAnnouncementsRepository',
    function(){
        return new EloquentAnnouncementsRepository(new Announcement);
    });

    //Task Repository
    $app->bind(
      'Trackr\Repository\Tasks\InterfaceTasksRepository',
    function(){
        return new EloquentTasksRepository(new Task);
    });


  }
}