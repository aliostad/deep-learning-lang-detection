<?php namespace PITG\Repository\Profile;

use PITG\Repository\EloquentBaseRepository;
use PITG\Repository\Profile\ProfileRepositoryInterface;
use Illuminate\Database\Eloquent\Model;

class EloquentProfileRepository extends EloquentBaseRepository  implements ProfileRepositoryInterface {

	/**
	 * Eloquent model
	 *
	 * @var Illuminate\Database\Eloquent\Model
	 */
	protected $profile;

	/**
	 * Embed model to instance
	 *
	 * @return 	void
	 */
	public function __construct(Model $profile)
	{
		parent::__construct($profile);
		$this->profile = $profile;
	}
}