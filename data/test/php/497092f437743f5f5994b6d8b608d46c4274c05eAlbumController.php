<?php

namespace App\Http\Controllers;

use App\Src\Album\AlbumRepository;
use App\Src\Category\CategoryRepository;

class AlbumController extends Controller
{
    /**
     * @var AlbumRepository
     */
    private $albumRepository;
    /**
     * @var CategoryRepository
     */
    private $categoryRepository;

    /**
     * @param AlbumRepository $albumRepository
     * @param CategoryRepository $categoryRepository
     */
    public function __construct(AlbumRepository $albumRepository, CategoryRepository $categoryRepository)
    {

        $this->albumRepository = $albumRepository;
        $this->categoryRepository = $categoryRepository;
    }

    /**
     * Show the application dashboard to the user.
     *
     * @return Response
     */
    public function index()
    {
        return view('admin.home');
    }

    public function show($id)
    {
        $album = $this->albumRepository->model->with([
            'tracks' => function ($q) {
                $q->latest()->limit(100);
            }
        ])->find($id);

        if (!$album->category) {
            return redirect()->back()->with('error', 'wrong access');
        }

        $category = $this->categoryRepository->model->with('albums.thumbnail', 'tracks')->find($album->category->id);

        $album->incrementViewCount();

        return view('modules.album.view', compact('album', 'category'));
    }

}
