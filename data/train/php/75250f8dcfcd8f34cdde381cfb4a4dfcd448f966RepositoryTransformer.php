<?php   namespace Library\Resources\Repositories;

use League\Fractal\TransformerAbstract;
use Library\Resources\Projects\ProjectTransformer;

class RepositoryTransformer extends TransformerAbstract{

    /**
     * List of resources possible to include
     *
     * @var array
     */
    protected $availableIncludes = [
        'projects',
    ];

    public function transform($repository)
    {
        return [
            'id'               => $repository['id'],
            'name'             => $repository['name'],
            'manager'          => $repository['manager'],
            'full_name'        => $repository['full_name'],
            'description'      => $repository['description'],
            'html_url'         => $repository['html_url'],
            'clone_url'        => $repository['clone_url'],
            'homepage'         => $repository['homepage'],
            'stargazers_count' => $repository['stargazers_count'],
            'language'         => $repository['language'],
        ];
    }

    /**
     * Include Product
     *
     * @param Repository $repository
     * @return League\Fractal\ItemResource
     */
    public function includeProject(Repository $repository)
    {
        $projects = $repository->projects;

        return $this->collection($projects, new ProjectTransformer);
    }
} 