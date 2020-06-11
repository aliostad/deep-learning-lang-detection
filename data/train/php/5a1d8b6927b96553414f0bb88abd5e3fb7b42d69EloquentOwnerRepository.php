<?php namespace SpartaPark\Repository\Owner;

use SpartaPark\Repository\AbstractEloquentRepository;
use Owner;

/**
 * Class EloquentOwnerRepository
 *
 * @package SpartaPark\Repository\Owner
 */
class EloquentOwnerRepository extends AbstractEloquentRepository implements OwnerRepository
{
   /**
    * @var Owner model
    */
   protected $owner;

   /**
    * Constructor
    *
    * @param Owner $owner model
    */
   public function __construct(Owner $owner)
   {
      parent::__construct($owner);
      $this->owner = $owner;
   }
}