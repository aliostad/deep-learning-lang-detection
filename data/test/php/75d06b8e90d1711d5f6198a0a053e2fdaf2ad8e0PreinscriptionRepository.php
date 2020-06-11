<?php 
namespace ModuleFormation\Repositories;

class PreinscriptionRepository extends AbstractRepository implements PreinscriptionRepositoryInterface
{
    protected $modelClassName = 'ModuleFormation\\Preinscription';

    function __construct($app, PreinscriptionSessionRepositoryInterface $preinscriptionSessionRepository) {
        parent::__construct($app);
        $this->preinscriptionSessionRepository = $preinscriptionSessionRepository;

        $this->subObjects = [
            [
                'data_id' => 'preinscription_sessions',
                'repository' => $this->preinscriptionSessionRepository,
                'parent_key' => 'preinscription_id',
            ]
        ];
    }
    
}