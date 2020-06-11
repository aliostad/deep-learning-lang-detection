<?php
namespace Services\Comment;

use Repositories\Comment\ICommentRepository as ICommentRepository;

class CommentService implements ICommentService
{
	public $commentRepository;

	public function __construct(ICommentRepository $commentRepository)
	{
		$this->commentRepository = $commentRepository;
	}

	public function all()
	{
		$results = $this->commentRepository->all();

		return $results;
	}

	public function create(array $data)
	{
		$this->commentRepository->create($data);
	}

	public function get($id)
	{
		$result = $this->commentRepository->get($id);

		return $result;
	}

	public function delete($id)
	{
		$this->commentRepository->delete($id);
	}
}