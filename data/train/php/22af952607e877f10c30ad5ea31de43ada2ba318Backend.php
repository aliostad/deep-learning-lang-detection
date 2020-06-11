<?php

/**
 * A set of primitive actions that can be made against any facade backend. These
 * primatives return {@link Facade_Response} objects subtyped for the specific
 * storage system.
 */
interface Facade_Backend
{
	/**
	 * Gets an object
	 * @param mixed {@link Facade_Path} or string
	 * @return Facade_Request
	 */
	public function get($path);

	/**
	 * Puts an object
	 * @param mixed {@link Facade_Path} or string
	 * @return Facade_Request
	 */
	public function put($path);

	/**
	 * Sends data to the backend
	 * @param mixed {@link Facade_Path} or string
	 * @param array key value data to send to the store
	 * @return Facade_Request
	 */
	public function post($path, $data);

	/**
	 * Deletes an object
	 * @param mixed {@link Facade_Path} or string
	 * @return Facade_Request
	 */
	public function delete($path);

	/**
	 * Gets an object's headers
	 * @param mixed {@link Facade_Path} or string
	 * @return Facade_Request
	 */
	public function head($path);
}
