<?php

namespace Fourum\Repository;

use Fourum\Forum\ForumRepositoryInterface;
use Fourum\Group\GroupRepositoryInterface;
use Fourum\Notification\NotificationRepositoryInterface;
use Fourum\Notification\Type\TypeRepositoryInterface;
use Fourum\Permission\GroupPermissionRepositoryInterface;
use Fourum\Permission\UserPermissionRepositoryInterface;
use Fourum\Post\PostRepositoryInterface;
use Fourum\Reporting\ReportRepositoryInterface;
use Fourum\Rule\RuleRepositoryInterface;
use Fourum\Thread\ThreadRepositoryInterface;
use Fourum\Tree\NodeRepositoryInterface;
use Fourum\User\Group\GroupRepositoryInterface as UserGroupRepositoryInterface;
use Fourum\User\UserRepositoryInterface;
use Illuminate\Support\ServiceProvider;

class RepositoryServiceProvider extends ServiceProvider
{
    /**
     * Register the service provider.
     *
     * @return void
     */
    public function register()
    {
        $this->app->singleton('Fourum\Repository\RepositoryRegistry', function ($app) {
            return new RepositoryRegistry($app, array(
                'user'              => UserRepositoryInterface::class,
                'forum'             => ForumRepositoryInterface::class,
                'group'             => GroupRepositoryInterface::class,
                'post'              => PostRepositoryInterface::class,
                'thread'            => ThreadRepositoryInterface::class,
                'report'            => ReportRepositoryInterface::class,
                'notification'      => NotificationRepositoryInterface::class,
                'notification.type' => TypeRepositoryInterface::class,
                'node'              => NodeRepositoryInterface::class,
                'user.group'        => UserGroupRepositoryInterface::class,
                'rule'              => RuleRepositoryInterface::class,
                'user.permission'   => UserPermissionRepositoryInterface::class,
                'group.permission'  => GroupPermissionRepositoryInterface::class,
            ));
        });

        $this->app->singleton('Fourum\Repository\RepositoryFactory', 'Fourum\Repository\RepositoryFactory');
    }
}