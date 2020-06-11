<?php
namespace tutons;

class CoreClass
{
	/* PROTECTED */
	protected $_facadeKey;

	public function initializeFacadeKey( $key )
	{
		$this->_facadeKey = $key;
	}

	public function getFacade()
	{
		if( is_null( $this->_facadeKey ) ) die( "No facade key has yet been initialized." );

		return Facade::getInstance( $this->_facadeKey );
	}

	public function getSystem()
	{
		return Facade::getInstance( Facade::KEY_SYSTEM );
	}

	/**
	*	Called by the framework when registered and in the facade scope.
	*/
	public function onRegister()
	{
		
	}
}