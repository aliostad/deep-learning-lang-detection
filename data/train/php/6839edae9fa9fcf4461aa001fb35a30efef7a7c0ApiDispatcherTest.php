<?php

class ApiDispatcherTest extends TestCase {

	/**
	 * @test
	 */
	public function shouldCallApiRoute()
	{
		// call api via api dispatcher
		$apiDispatcher = new ApiDispatcher();
		$apiResponse = $apiDispatcher->callApiRoute('api_logout', []);

		// check response
		$this->assertInstanceOf('ApiResponse', $apiResponse);
	}

	/**
	 * @test
	 */
	public function shouldBackupAndRestoreOriginalRequestInput()
	{
		// add key - value pair to the request
		Input::merge(['foo' => 'bar']);

		// call api via api dispatcher
		$apiDispatcher = new ApiDispatcher();
		$apiDispatcher->callApiRoute('api_logout');

		// check if request data is the same after API call
		$this->assertEquals('bar', Input::get('foo'));
		$this->assertEquals(['foo' => 'bar'], Input::all());
	}

}
