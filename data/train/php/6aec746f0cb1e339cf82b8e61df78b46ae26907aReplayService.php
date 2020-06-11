<?php


namespace App\Services;


use App\Repositories\MessageRepository;
use App\Repositories\ReplayRepository;
use Auth;
use Image;
use Storage;

class ReplayService
{

	/**
	 * @var ReplayRepository
	 */
	private $replayRepository;
	/**
	 * @var MessageRepository
	 */
	private $messageRepository;

	/**
	 * ReplayService constructor.
	 *
	 * @param ReplayRepository $replayRepository
	 * @param MessageRepository $messageRepository
	 */
	public function __construct(ReplayRepository $replayRepository, MessageRepository $messageRepository)
	{
		$this->replayRepository = $replayRepository;
		$this->messageRepository = $messageRepository;
	}

	/**
	 * 新增回覆
	 *
	 * @param array $data
	 * @return \App\Models\Reply
	 */
	public function addReplay(array $data)
	{
		$message = $this->messageRepository->find($data['id']);

		return $this->replayRepository->createReplay($data, Auth::user()->id, $message->id);
	}

}