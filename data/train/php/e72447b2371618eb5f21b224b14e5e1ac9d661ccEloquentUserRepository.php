<?php namespace MPP\Repository\User;

use MPP\Repository\AbstractEloquentRepository;
use User;

/**
 * Class EloquentUserRepository
 *
 * @package MPP\Repository\User
 */
class EloquentUserRepository extends AbstractEloquentRepository implements UserRepository
{
   /**
    * User model.
    *
    * @var User
    */
   protected $user;

   /**
    * Constructor.
    *
    * @param User $user
    */
   public function __construct(User $user)
   {
      parent::__construct($user);
      $this->user = $user;
   }
}