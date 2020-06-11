<?php

use HireMe\Repositories\CategoryRepository;
use Illuminate\Support\Facades\View;
use HireMe\Repositories\CandidateRepository;

class CandidatesController extends BaseController {
	
	protected $categoryRepository;
	protected $candidateRepository;
	
	public function __construct(CategoryRepository $categoryRepository, CandidateRepository $candidateRepository) // inyector de dependencias.
	{
		$this->categoryRepository = $categoryRepository;
		$this->candidateRepository = $candidateRepository;
	}
	
	public function category($slug, $id)
	{
		$category = $this->categoryRepository->find($id);
		return View::make('candidates/category', compact('category'));
	}
	
	
	public function show($slug, $id)
	{
		$candidate = $this->candidateRepository->find($id);
		return View::make('candidates/show', compact('candidate'));
	}
	
	
}