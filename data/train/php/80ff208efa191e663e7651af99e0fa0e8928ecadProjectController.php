<?php namespace App\Http\Controllers;

use App\Domain\Project\Repository\EloquentRepository as Repository;
use App\Domain\Project\Criteria\BelongsToUser;
use App\User;

class ProjectController extends Controller {

    protected $Repository;

    public function __construct(Repository $Repository)
    {
        $this->Repository = $Repository;
    }

	public function index()
	{
        return $this->Repository->all();
	}

    public function show($id)
    {
        return $this->Repository->findByID($id);
    }

    public function byUser()
    {
        $User = User::find(1);
        return $this->Repository->findByUser($User);
    }
}
