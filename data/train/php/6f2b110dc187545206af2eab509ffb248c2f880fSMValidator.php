<?php
namespace Core\Validator;

use Core\Service\AbstractService;
use Core\Exception\InvalidServiceException;
use Zend\Validator\AbstractValidator;
use Zend\Validator\Exception\InvalidArgumentException;

abstract class SMValidator extends AbstractValidator
{
    /**
     * @var Core\Service\AbstractService
     */
	protected $service;
			
	public function __construct($options = null)
	{
		if($options instanceof AbstractService){
			$this->setService($options);
		}else{
		
			if(!isset($options['service']) OR  ! $options['service'] instanceof AbstractService ){
				throw new InvalidServiceException("Invalid service instance, AbstractService is requiered");
			}
			
			$this->setService($options['service']);
			unset($options['service']);
		}
		
		parent::__construct($options);
	}
	
	/**
	 * Return AbstractService instance
	 * @return AbstractService $service
	 */
	protected function getService()
	{
		return $this->service; 
	}
	
	/**
	 * Set AbstractService instance
	 * @param AbstractService $service
	 * @return SMValidator self 
	*/
	protected function setService(AbstractService $service)
	{
		$this->service = $service;
		return $this;
	}
	
	/**
	 * Checks that an option is set
	 * @param string $option
	 * @return boolean
	 */
	public function hasOption($option)
	{
		try {
			$this->getOption($option);
			return true;
		}catch (InvalidArgumentException $e){
			return false;
		}
	}
	
}

