<?php namespace Trackr\Repository\Departments;

use Illuminate\Database\Eloquent\Model;

use Trackr\Repository\EloquentBaseRepository;
use Trackr\Repository\Departments\InterfaceDepartmentsRepository;

class EloquentDepartmentsRepository extends EloquentBaseRepository implements InterfaceDepartmentsRepository
{
  /**
   * Eloquent model
   *
   * @var Illuminate\Database\Eloquent\Model
   */
  protected $department;

  public function __construct(Model $department)
  {
    parent::__construct($department);
    $this->department = $department;
  }
}