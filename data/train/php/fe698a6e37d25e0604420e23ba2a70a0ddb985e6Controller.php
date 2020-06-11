<?php

namespace App\Http\Controllers;

use App\Http\Repository\BlogRepository;
use App\Http\Repository\UserRepository;
use App\Http\Repository\ReviewRepository;
use App\Http\Repository\CommentRepository;
use App\Http\Repository\CompanyRepository;

use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Foundation\Validation\ValidatesRequests;

abstract class Controller extends BaseController
{
	use DispatchesJobs, ValidatesRequests;

	public function __construct()
	{
		$this->blogRepository 	= new BlogRepository;
		$this->userRepository 	= new UserRepository;
		$this->reviewRepository 	= new ReviewRepository;
		$this->companyRepository 	= new CompanyRepository;
		$this->commentRepository 	= new CommentRepository;
	}
}
