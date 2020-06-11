<?php

Class Controller extends BaseController
{

    public function __construct()
    {
        $this->getService('Session');
    }

    /**
     * @return \FrontRepository
     */
    public function getFrontRepository()
    {
        return $this->getService('Database')->getRepository('Front');
    }
	
    /**
     * @return \AjaxFrontRepository
     */
    public function getAjaxFrontRepository()
    {
        return $this->getService('Database')->getRepository('AjaxFront');
    }

    /**
     * @return \AdminRepository
     */
    public function getAdminRepository()
    {
        return $this->getService('Database')->getRepository('Admin');
    }

    /**
     * @return \AjaxAdminRepository
     */
    public function getAjaxAdminRepository()
    {
        return $this->getService('Database')->getRepository('AjaxAdmin');
    }
}