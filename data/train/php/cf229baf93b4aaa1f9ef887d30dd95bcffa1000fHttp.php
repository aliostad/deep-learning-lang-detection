<?php

/**
 * A simple HTTP backend
 */
class Facade_Http implements Facade_Backend
{
	private $_host;
	private $_port;
	private $_timeout;

	/**
	 * Constructor
	 */
	public function __construct($host, $port, $timeout=30)
	{
		$this->_host = $host;
		$this->_port = $port;
		$this->_timeout = $timeout;
	}

	/* (non-phpdoc)
	 * @see Facade_Backend::put()
	 */
	public function put($path)
	{
		return $this
			->buildRequest(Facade_Http_Request::METHOD_PUT, $path);
	}

	/* (non-phpdoc)
	 * @see Facade_Backend::get()
	 */
	public function get($path)
	{
		return $this
			->buildRequest(Facade_Http_Request::METHOD_GET, $path);
	}

	/* (non-phpdoc)
	 * @see Facade_Backend::head()
	 */
	public function head($path)
	{
		return $this
			->buildRequest(Facade_Http_Request::METHOD_HEAD, $path);
	}

	/* (non-phpdoc)
	 * @see Facade_Backend::post()
	 */
	public function post($path, $data)
	{
		throw new BadMethodCallException(__METHOD__ . ' not implemented');
	}

	/* (non-phpdoc)
	 * @see Facade_Backend::delete()
	 */
	public function delete($path)
	{
		throw new BadMethodCallException(__METHOD__ . ' not implemented');
	}

	/**
	 * Builds an HTTP request
	 */
	private function buildRequest($method, $path)
	{
		return new Facade_Http_Request(
			new Facade_Http_Socket($this->_host, $this->_port, $this->_timeout),
			$method,
			$path
			);
	}
}
