<?php namespace Ssms\Repositories;

use Illuminate\Support\ServiceProvider;

class StorageServiceProvider extends ServiceProvider {

	public function register()
	{
		$this->app->bind('Ssms\Repositories\User\UserRepository', 'Ssms\Repositories\User\EloquentUserRepository');
		$this->app->bind('Ssms\Repositories\Role\RoleRepository', 'Ssms\Repositories\Role\EloquentRoleRepository');
		$this->app->bind('Ssms\Repositories\Permission\PermissionRepository', 'Ssms\Repositories\Permission\EloquentPermissionRepository');
		$this->app->bind('Ssms\Repositories\Option\OptionRepository', 'Ssms\Repositories\Option\EloquentOptionRepository');
		$this->app->bind('Ssms\Repositories\QuickLink\QuickLinkRepository', 'Ssms\Repositories\QuickLink\EloquentQuickLinkRepository');
		$this->app->bind('Ssms\Repositories\Page\PageRepository', 'Ssms\Repositories\Page\EloquentPageRepository');
		$this->app->bind('Ssms\Repositories\Notification\NotificationRepository', 'Ssms\Repositories\Notification\EloquentNotificationRepository');
		$this->app->bind('Ssms\Repositories\Event\EventRepository', 'Ssms\Repositories\Event\EloquentEventRepository');
		$this->app->bind('Ssms\Repositories\Service\ServiceRepository', 'Ssms\Repositories\Service\EloquentServiceRepository');
		$this->app->bind('Ssms\Repositories\Server\ServerRepository', 'Ssms\Repositories\Server\EloquentServerRepository');
	}

}