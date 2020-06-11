<?php

/**
 * Created by PhpStorm.
 * User: paulo
 * Date: 13/01/2016
 * Time: 17:31
 */
namespace CodeDelivery\Services;

use CodeDelivery\Repositories\ClientRepository;
use CodeDelivery\Repositories\ClientRepositoryEloquent;
use CodeDelivery\Repositories\UserRepository;
use CodeDelivery\Repositories\UserRepositoryEloquent;

class ClientService
{
    /**
     * @var UserRepository
     */
    private $userRepository;
    /**
     * @var ClientRepository
     */
    private $clientRepository;

    public function __construct(ClientRepositoryEloquent $clientRepository, UserRepositoryEloquent $userRepository)
    {
        $this->clientRepository = $clientRepository;
        $this->userRepository = $userRepository;
    }

    public function update($data, $id)
    {
        $userId = $this->clientRepository->find($id, ['user_id'])->user_id;
        $this->clientRepository->update($data, $id);

        $this->userRepository->update([
            'name' => $data['name'],
            'email' => $data['email']
        ], $userId);
    }

    public function create($data)
    {
        $user = array(
            'name' => $data['name'],
            'password' => bcrypt(123456),
            'email' => $data['email'],
            'role' => 'client'
        );
        $userId = $this->userRepository->create($user);
        $data['user_id'] = $userId->id;
        $this->clientRepository->create($data);

    }

}