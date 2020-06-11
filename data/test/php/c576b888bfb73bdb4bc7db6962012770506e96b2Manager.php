<?php
/*
 *  TRINITY FRAMEWORK <http://www.invenzzia.org>
 *
 * This file is subject to the new BSD license that is bundled
 * with this package in the file LICENSE. It is also available through
 * WWW at this URL: <http://www.invenzzia.org/license/new-bsd>
 *
 * Copyright (c) Invenzzia Group <http://www.invenzzia.org>
 * and other contributors. See website for details.
 */

namespace Trinity\Web\Facade;

/**
 * The facade manager simplifies the management of the available facades
 * and allows the selection of one of them to be used on the page.
 *
 * @author Tomasz Jędrzejewski
 * @copyright Invenzzia Group <http://www.invenzzia.org/> and contributors.
 * @license http://www.invenzzia.org/license/new-bsd New BSD License
 */
class Manager
{
	/**
	 * Maps the facade name to the corresponding class name.
	 * @var array
	 */
	private $_facadeClassNames = array();
	
	/**
	 * The currently selected facade.
	 * @var string
	 */
	private $_selectedFacade = null;

	/**
	 * Registers a new facade class under the specified name. The registered
	 * class must extend \Trinity\Web\Brick interface. Note that the interface
	 * is not checked within this method.
	 *
	 * Implements fluent interface.
	 *
	 * @throws \Trinity\Web\Facade\Exception
	 * @param string $name The short name of the facade.
	 * @param string $className The full facade class name.
	 * @return \Trinity\Web\Facade
	 */
	public function addFacade($name, $className)
	{
		if(isset($this->_facadeClassNames[$name]))
		{
			throw new Exception('The facade "'.$name.'" already exists.');
		}
		$this->_facadeClassNames[$name] = $className;

		return $this;
	} // addFacade();

	/**
	 * Returns true, if the facade is defined.
	 *
	 * @param string $name The facade name
	 * @return boolean
	 */
	public function hasFacade($name)
	{
		return isset($this->_facadeClassNames[$name]);
	} // end hasFacade();

	/**
	 * Returns the class name of the specified facade. An exception is
	 * thrown, if the facade does not exist.
	 *
	 * Implements fluent interface.
	 *
	 * @throws \Trinity\Web\Facade\Exception
	 * @param string $name The facade to select
	 * @return string
	 */
	public function getFacade($name)
	{
		if(!isset($this->_facadeClassNames[$name]))
		{
			throw new Exception('The facade "'.$name.'" does not exist.');
		}
		return $this->_facadeClassNames[$name];
	} // end getFacade();

	/**
	 * Removes the facade. If the facade is already selected, the selection
	 * is resetted.
	 *
	 * Implements fluent interface.
	 *
	 * @throws \Trinity\Web\Facade\Exception
	 * @param string $name The facade to select
	 * @return \Trinity\Web\Facade\Manager
	 */
	public function removeFacade($name)
	{
		if(!isset($this->_facadeClassNames[$name]))
		{
			throw new Exception('The facade "'.$name.'" does not exist.');
		}
		unset($this->_facadeClassNames[$name]);

		if($name == $this->_selectedFacade)
		{
			$this->_selectedFacade = null;
		}
	} // end removeFacade();

	/**
	 * Selects the facade to be used within the request. If the facade is not
	 * registered within the manager, an exception is thrown.
	 *
	 * Implements fluent interface.
	 *
	 * @throws \Trinity\Web\Facade\Exception
	 * @param string $name The facade to select
	 * @return \Trinity\Web\Facade\Manager
	 */
	public function select($name)
	{
		if(!isset($this->_facadeClassNames[$name]))
		{
			throw new Exception('Cannot select the facade: facade "'.$name.'" does not exist.');
		}
		$this->_selectedFacade = $name;

		return $this;
	} // end select();

	/**
	 * Returns the name of the selected facade or null, if the facade is not
	 * set.
	 *
	 * @return string
	 */
	public function getSelectedFacade()
	{
		return $this->_selectedFacade;
	} // end getSelectedFacade();

	/**
	 * Returns the class name of the selected facade. If no facade is selected,
	 * it returns NULL.
	 *
	 * @return string
	 */
	public function getSelectedFacadeClass()
	{
		if($this->_selectedFacade == null)
		{
			return null;
		}
		return $this->_facadeClassNames[$this->_selectedFacade];
	} // getSelectedFacadeClass();
} // end Manager;