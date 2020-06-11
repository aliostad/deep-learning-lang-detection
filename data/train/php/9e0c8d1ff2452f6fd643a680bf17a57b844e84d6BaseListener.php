<?php

namespace Krombox\MainBundle\EventListener;

/**
 * @author Roman Kapustian <ikrombox@gmail.com>
 */

use Doctrine\Common\EventSubscriber;
use Krombox\MainBundle\Handler\UploadHandler;

abstract class BaseListener  implements EventSubscriber
{
    /**
     * @var UploaderHandler $handler
     */
    protected $handler;
    
    /**
     * Constructs a new instance of UploaderListener.     
     * @param UploaderHandler  $handler  The upload handler.
     */
    public function __construct(UploadHandler $handler)
    {        
        $this->handler = $handler;
    }    
}
