<?php

namespace ThePot\Interactor;

use ThePot\Validator\NoticeValidator;
use ThePot\Repository\NoticeRepository;
use ThePot\Entity\NoticeEntity;

class CreateNoticeInteractor
{
	private $validator;
	private $repository;

    public function __construct(
        NoticeValidator $validator,
        NoticeRepository $repository
	) {
        $this->validator = $validator;
		$this->repository = $repository;
    }

	public function execute(array $data)
	{
		$notice = new NoticeEntity($data);

		$this->validator->validate($notice);

		$this->repository->create($notice);
	}
}
