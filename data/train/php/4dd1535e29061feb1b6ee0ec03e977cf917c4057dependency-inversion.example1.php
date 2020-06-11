<?php

namespace Foo\Bar\Domain\Service;

use Foo\Bar\Infrastructure\Repository\UserMySqlRepository;

class UserService
{
	public function __construct(
		UserMySqlRepository $repo
	) {
		// ...
	}
}








namespace Foo\Bar\Domain\Service;

use Foo\Bar\Domain\Repository\UserRepository;

class UserService
{
	public function __construct(
		UserRepository $repo
	) {
		// ...
	}
}







namespace Foo\Bar\Infrastructure\Repository\UserMySqlRepository;

use Foo\Bar\Domain\Repository\UserRepository;

class UserMySqlRepository implements UserRepository
{
	public function __construct(
		UserRepository $repo
	) {
		// ...
	}
}






