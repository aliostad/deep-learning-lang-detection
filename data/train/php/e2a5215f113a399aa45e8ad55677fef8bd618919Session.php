<?php
/**
 * Zend Framework for Xoops Engine
 *
 * You may not change or alter any portion of this comment or credits
 * of supporting developers from this source code or any supporting source code
 * which is considered copyrighted (c) material of the original comment or credit authors.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * @copyright       Xoops Engine http://www.xoopsengine.org/
 * @license         http://www.fsf.org/copyleft/gpl.html GNU public license
 * @author          Taiwen Jiang <phppp@users.sourceforge.net>
 * @since           3.0
 * @category        Xoops_Zend
 * @package         Application
 * @subpackage      Resource
 * @version         $Id$
 */

class Xoops_Zend_Application_Resource_Session extends Zend_Application_Resource_ResourceAbstract
{
    /**
     * Resource type
     */
    protected $_explicitType = "session";

    /**
     * Save handler to use
     *
     * @var Zend_Session_SaveHandler_Interface
     */
    protected $saveHandler = null;

    /**
     * Set session save handler
     *
     * @param  array|string|Zend_Session_SaveHandler_Interface $saveHandler
     * @return Zend_Application_Resource_Session
     */
    public function setSaveHandler($saveHandler)
    {
        $this->saveHandler = $saveHandler;
        return $this;
    }

    /**
     * Set session save handler
     *
     * @param  array|string|Zend_Session_SaveHandler_Interface $saveHandler
     * @return Zend_Application_Resource_Session
     */
    protected function loadSaveHandler()
    {
        $saveHandler = $this->saveHandler;
        $type = "";
        $class = "";
        $options = array();
        if (is_array($saveHandler)) {
            if (array_key_exists('class', $saveHandler)) {
                $class = $saveHandler['class'];
            } elseif (array_key_exists('type', $saveHandler)) {
                $type = $saveHandler['type'];
            }
            if (array_key_exists('options', $saveHandler)) {
                $options = $saveHandler['options'];
            } else {
                $options = array();
            }
        } elseif (is_string($saveHandler)) {
            $type = $saveHandler;
        }
        if ($type) {
            $type = ucfirst($type);
            if ($type === 'Db') {
                $this->getBootstrap()->bootstrap('Db');
            }
            $class = "Zend_Session_SaveHandler_" . $type;
            if (class_exists("Xoops_" . $class)) {
                $class = "Xoops_" . $class;
            }
        }
        if ($saveHandler instanceof Zend_Session_SaveHandler_Interface) {
        } elseif (!empty($class)) {
            $saveHandler = new $class($options);
        } else {
            throw new Exception('No valid saveHandler is provided!');
        }

        if (!($saveHandler instanceof Zend_Session_SaveHandler_Interface)) {
            $saveHandler = null;
        }

        return $saveHandler;
    }

    /**
     * Defined by Zend_Application_Resource_Resource
     *
     * @return void
     */
    public function init()
    {
        $options = array_change_key_case($this->getOptions(), CASE_LOWER);
        if (isset($options['savehandler'])) {
            unset($options['savehandler']);
        }

        if (!isset($options["cookie_path"]) && $baseUrl = XOOPS::host()->get('baseUrl')) {
            $options["cookie_path"] = rtrim($baseUrl, "/") . "/";
        }
        Xoops::service("session")->setOptions($options);

        if (!empty($this->saveHandler)) {
            $saveHandler = $this->loadSaveHandler();
            Xoops::service("session")->setSaveHandler($saveHandler);
        }
        Xoops::service("session")->start();
    }
}