<?php
/**
 * Created by PhpStorm.
 * User: zhu
 * Email: ylsc633@gmail.com
 * Date: 2017/6/5
 * Time: 上午11:43
 */
namespace App\Providers;

use App\Repositories\Contracts\AppendRepositoryInterface;
use App\Repositories\Contracts\GithubUserRepositoryInterface;
use App\Repositories\Contracts\InviteCodeRepositoryInterface;
use App\Repositories\Contracts\NodeRepositoryInterface;
use App\Repositories\Contracts\NotifyRepositoryInterface;
use App\Repositories\Contracts\PermissionRepositoryInterface;
use App\Repositories\Contracts\PostRepositoryInterface;
use App\Repositories\Contracts\ReplyRepositoryInterface;
use App\Repositories\Contracts\RoleRepositoryInterface;
use App\Repositories\Contracts\RoleUserRepositoryInterface;
use App\Repositories\Contracts\TagRepositoryInterface;
use App\Repositories\Contracts\UserRepositoryInterface;
use App\Repositories\Contracts\WeiBoUserRepositoryInterface;
use App\Repositories\Contracts\XcxUserRepositoryInterface;
use App\Repositories\Eloquent\AppendRepository;
use App\Repositories\Eloquent\GithubUserRepository;
use App\Repositories\Eloquent\InviteCodeRepository;
use App\Repositories\Eloquent\NodeRepository;
use App\Repositories\Eloquent\NotifyRepository;
use App\Repositories\Eloquent\PermissionRepository;
use App\Repositories\Eloquent\PostRepository;
use App\Repositories\Eloquent\ReplyRepository;
use App\Repositories\Eloquent\RoleRepository;
use App\Repositories\Eloquent\RoleUserRepository;
use App\Repositories\Eloquent\TagRepository;
use App\Repositories\Eloquent\UserRepository;
use App\Repositories\Eloquent\WeiBoUserRepository;
use App\Repositories\Eloquent\XcxUserRepository;
use Illuminate\Support\ServiceProvider;

class RepositoryServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        //
    }
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        $this->app->bind(UserRepositoryInterface::class,UserRepository::class);
        $this->app->bind(InviteCodeRepositoryInterface::class,InviteCodeRepository::class);
        $this->app->bind(GithubUserRepositoryInterface::class,GithubUserRepository::class);
        $this->app->bind(PostRepositoryInterface::class,PostRepository::class);
        $this->app->bind(NodeRepositoryInterface::class,NodeRepository::class);
        $this->app->bind(TagRepositoryInterface::class,TagRepository::class);
        $this->app->bind(AppendRepositoryInterface::class,AppendRepository::class);
        $this->app->bind(ReplyRepositoryInterface::class,ReplyRepository::class);
        $this->app->bind(PermissionRepositoryInterface::class,PermissionRepository::class);
        $this->app->bind(RoleRepositoryInterface::class,RoleRepository::class);
        $this->app->bind(NotifyRepositoryInterface::class,NotifyRepository::class);
        $this->app->bind(WeiBoUserRepositoryInterface::class,WeiBoUserRepository::class);
        $this->app->bind(XcxUserRepositoryInterface::class,XcxUserRepository::class);
        $this->app->bind(RoleUserRepositoryInterface::class,RoleUserRepository::class);
    }
}