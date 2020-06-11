<?php  namespace Acme\AccessControl\Roles; 

use Laracasts\Commander\CommandHandler;
use Role;

class ChangeRoleNameCommandHandler implements CommandHandler {

    protected $repository;

    /**
     * @param RoleRepository $repository
     */
    function __construct(RoleRepository $repository)
    {
        $this->repository = $repository;
    }


    /**
     * Handle the command
     *
     * @param $command
     * @return mixed
     */
    public function handle($command)
    {
        $role = Role::find($command->pk);

        $role = Role::changeName($role, $command->value);

        return $this->repository->save($role);
    }
}