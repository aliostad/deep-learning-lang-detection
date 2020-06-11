<?php namespace PITG\Repository\Message;

use PITG\Repository\EloquentBaseRepository;
use PITG\Repository\Message\MessageRepositoryInterface;
use Illuminate\Database\Eloquent\Model;

class EloquentMessageRepository extends EloquentBaseRepository  implements MessageRepositoryInterface {
	
	/**
	 * Eloquent model
	 *
	 * @var Illuminate\Database\Eloquent\Model
	 */
	protected $message;

	/**
	 * Embed model to instance
	 *
	 * @return 	void
	 */
	public function __construct(Model $message)
	{
		parent::__construct($message);
		$this->message = $message;
	}
}