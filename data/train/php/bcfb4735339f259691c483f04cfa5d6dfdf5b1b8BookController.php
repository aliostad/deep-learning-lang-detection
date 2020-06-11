<?php namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Repositories\BookRepository;
use App\Repositories\CategoryRepository;
use App\Repositories\PeriodRepository;
use App\Repositories\AuthorRepository;
use App\Repositories\ThemeRepository;
use App\Repositories\EditorRepository;
use App\Repositories\FormatRepository;
use App\Http\Requests\SharedRequest;

use Illuminate\Http\Request;

class BookController extends Controller {

	/**
	 * Create BookController instance.
	 *
	 * @param  App\Repositories\BookRepository  $repository
	 * @return void
	 */
	public function __construct(BookRepository $repository)
	{
		$this->repository = $repository;

		$this->base = 'books';
		
		$this->message_store = 'The book has been added';
		$this->message_update = 'The book has been updated';
		$this->message_delete = 'The book has been deleted';

		$this->middleware('ajax', ['only' => ['store', 'update']]);
	}

	/**
	 * Display the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function show($id)
	{
		$book = $this->repository->getByIdWithAuthorsAndThemeAndBookable($id);

		return view($this->base.'.show', compact('book'));
	}

	/**
	 * Show the form for creating a new resource.
	 *
	 * @param  App\Repositories\AuthorRepository $authorRepository
	 * @param  App\Repositories\ThemeRepository $themeRepository
	 * @param  App\Repositories\EditorRepository $editorRepository
	 * @param  App\Repositories\FormatRepository $formatRepository
	 * @return Response
	 */
	public function create(
		AuthorRepository $authorRepository,
		ThemeRepository $themeRepository,
		EditorRepository $editorRepository,
		FormatRepository $formatRepository)
	{
		$authors = $authorRepository->getAllSelect();
		$themes = $themeRepository->getAllSelect();
		$editors = $editorRepository->getAllSelect();
		$formats = $formatRepository->getAllSelect();

		return view($this->base.'.create', compact('authors', 'themes', 'editors', 'formats'));
	}

	/**
	 * Store a newly created resource in storage.
	 *
	 * @param  App\Http\Requests\SharedRequest $request
	 * @return Response
	 */
	public function store(SharedRequest $request)
	{
		$book = $this->repository->store($request->all());

		session()->flash('message_success', $this->message_store);

		return response()->json();
	}

	/**
	 * Show the form for editing the specified resource.
	 *
	 * @param  App\Repositories\AuthorRepository $authorRepository
	 * @param  App\Repositories\ThemeRepository $themeRepository
	 * @param  App\Repositories\EditorRepository $editorRepository
	 * @param  App\Repositories\FormatRepository $formatRepository
	 * @param  int  $id
	 * @return Response
	 */
	public function edit(
		AuthorRepository $authorRepository,
		ThemeRepository $themeRepository,
		EditorRepository $editorRepository,
		FormatRepository $formatRepository,
		$id)
	{
		$book = $this->repository->getByIdWithAuthorsAndThemeAndBookable($id);
		$type_editor = $this->repository->getTypeEditor($book);

		$authors = $authorRepository->getAllSelect();
		$themes = $themeRepository->getAllSelect();
		$editors = $editorRepository->getAllSelect();
		$formats = $formatRepository->getAllSelect();

		return view($this->base.'.edit', compact('book', 'authors', 'themes', 'editors', 'formats', 'type_editor'));
	}

	/**
	 * Update the specified resource in storage.
	 *
	 * @param  App\Http\Requests\SharedRequest $request
	 * @param  int  $id
	 * @return Response
	 */
	public function update(SharedRequest $request, $id)
	{
		$book = $this->repository->update($id, $request->all());

		session()->flash('message_success', $this->message_store);

		return response()->json();
	}

}
