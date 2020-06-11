<?php namespace Trackr\Repository\Announcements;

use Illuminate\Database\Eloquent\Model;

use Trackr\Repository\EloquentBaseRepository;
use Trackr\Repository\Announcements\InterfaceAnnouncementsRepository;

class EloquentAnnouncementsRepository extends EloquentBaseRepository implements InterfaceAnnouncementsRepository
{
  /**
   * Eloquent model
   *
   * @var Illuminate\Database\Eloquent\Model
   */
  protected $announcement;

  public function __construct(Model $announcement)
  {
    parent::__construct($announcement);
    $this->announcement = $announcement;
  }
}