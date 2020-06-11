<?php  namespace Acme\AccessControl\Roles; 

use Laracasts\Commander\CommandHandler;
use Role;

class DeleteRoleCommandHandler implements CommandHandler {

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
        $role = Role::deleteRole(
          $command->id
        );

        return $this->repository->deleteRole($role);
    }
}