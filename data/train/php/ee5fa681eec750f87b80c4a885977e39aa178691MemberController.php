<?php

namespace App\Http\Controllers\User;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Repositories\Member\MemberRepository;
use App\Repositories\Category\CategoryRepository;
use App\Repositories\User\UserRepository;
use App\Repositories\Book\BookRepository;
use App\Http\Requests\CreateMemberRequest;
use App\Http\Requests\UpdateMemberRequest;
use Session;
use App\Models\Book;

class MemberController extends Controller
{
    protected $memberRepository;
    protected $bookRepository;
    protected $userRepository;
    protected $categoryRepository;

    public function __construct(MemberRepository $memberRepository, BookRepository $bookRepository, UserRepository $userRepository, CategoryRepository $categoryRepository)
    {
        $this->memberRepository = $memberRepository;
        $this->bookRepository = $bookRepository;
        $this->userRepository = $userRepository;
        $this->categoryRepository = $categoryRepository;
    }
     public function show($id)
    {
        $member = $this->userRepository->find($id);
        $categories = $this->categoryRepository->getCategory();
        $books = Book::where('member_id', '=', $id)->paginate(trans('book.limit'));
        return view('user.member.profile', compact('member', 'books', 'categories'));
    }

}
