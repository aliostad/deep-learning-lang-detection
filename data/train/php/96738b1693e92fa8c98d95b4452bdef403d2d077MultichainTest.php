<?php

namespace Lenh\Multichain\Tests\Facades;

use Be\Kunstmaan\Multichain\MultichainClient;

use Lenh\Multichain\Facades\MultiChain;
use Lenh\Multichain\Tests\AbstractTestCase;
use GrahamCampbell\TestBenchCore\FacadeTrait;



/**
* Service provider test class.
*/

class MultichainTest extends AbstractTestCase
{
	use FacadeTrait;
	
	/**
	* Get facade accessor.
	*
	* @return string
	*/
	protected function getFacadeAccessor()
	{
		return 'multichain';
	}
	
	/**
	* Get facade class.
	*
	* @return string
	*/
	protected function getFacadeClass()
	{
		return MultiChain::class;
	}
	
	/**
	* Get facade root.
	*
	* @return string
	*/
	protected function getFacadeRoot()
	{
		return MultichainClient::class;
	}
}