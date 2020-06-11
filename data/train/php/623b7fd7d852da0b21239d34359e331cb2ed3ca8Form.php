<?php
class Shopware_Components_Form extends Zend_Form
{
	const SCOPE_SHOP = 1;
	const SCOPE_LOCALE = 2;
	
	protected $_id = null;
	protected $_saveHandler = null;
	
	public function save()
	{
		if($this->_saveHandler!==null) {
			$this->_saveHandler->save($this);
		}
	}
	
	public function load()
	{
		if($this->_saveHandler!==null) {
			$this->_saveHandler->load($this);
		}
	}
	
	public function setId($id)
	{
		$this->_attribs['id'] = $id;
		return $this;
	}
	
	public function setSaveHandler($saveHandler)
	{
		$this->_saveHandler = $saveHandler;
	}
	
	public function setElement($element, $name, $options = null)
    {
    	$this->removeElement($name);
    	return $this->addElement($element, $name, $options);
    }
}