<?php
/**
 * @author lucas.wawrzyniak
 * @copyright Copyright (c) 2013 Lucas Wawrzyniak
 * @licence New BSD License
 */

namespace SMS\Model\Adapter;

use \SMS\Model\Number;
use \SMS\Model\Content;
use \SMS\Facade;

class Mock extends AdapterAbstract
{
    /**
     * @var \SMS\Facade
     */
    protected $facadeSMS;

    /**
     * @param \SMS\Facade $facade
     */
    public function setFacadeSMS(Facade $facade)
    {
        $this->facadeSMS = $facade;
    }

    /**
     * @param \SMS\Model\Number $from
     * @param \SMS\Model\Number $to
     * @param \SMS\Model\Content $content
     * @return bool
     */
    public function send(Number $from, Number $to, Content $content)
    {
        return true;
    }
}