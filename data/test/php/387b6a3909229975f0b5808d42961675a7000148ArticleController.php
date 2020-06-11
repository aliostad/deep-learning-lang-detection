<?php

namespace App\Http\Controllers;

use App\Repositories\ArticleRepository;
use Illuminate\Http\Response;

class ArticleController extends Controller
{
	protected $repostory;

    // 利用 Service Container (DI) 來自動注入 ArticleRepository
    public function __construct(ArticleRepository $repository)
    {
        $this->repository = $repository;
    }

    public function index()
    {
        // 改成從 ArticleRepository 中取得資料
        $articles = $this->repository->latest10();

        return view('article.index', compact('articles'));
    }
}
