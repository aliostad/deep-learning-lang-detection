<?php
/**
 * Created by PhpStorm.
 * User: Gustavo
 * Date: 18/02/2017
 * Time: 16:48
 */

namespace codedelivery\Service;

use codedelivery\Repositories\ClientsRepository;
use codedelivery\Repositories\UserRepositoryEloquent;

class ClientService
{
    private $clientsRepository;
    private $userRepository;

    public function __construct(ClientsRepository $clientsRepository, UserRepositoryEloquent $userRepository)
    {
        $this->clientsRepository = $clientsRepository;
        $this->userRepository = $userRepository;
    }

    public function update(array $data, $id)
    {
        $this->clientsRepository->update($data, $id);

        $userId = $this->clientsRepository->find($id, ['user_id'])->user_id;

        $this->userRepository->update($data['user'], $userId);
    }

    public function create(array $data)
    {
        $user = $this->userRepository->create($data['user']);

        $data['user_id'] = $user->id;

        $this->clientsRepository->create($data);

    }
}