<?php

/**
 * =============================================================================
 * @file       Commons/FileSystem/FileLocatorAwareInterface.php
 * @author     Lukasz Cepowski <lukasz@cepowski.com>
 * 
 * @copyright  PHP Commons
 *             Copyright (C) 2009-2013 PHP Commons Contributors
 *             All rights reserved.
 *             www.phpcommons.com
 * =============================================================================
 */

namespace Commons\Light\View\Phtml;

interface FileLocatorAwareInterface
{
    
    /**
     * Set file locator.
     * @param FileLocator $locator
     * @return FileLocatorAwareInterface
     */
    public function setFileLocator(FileLocator $locator);
    
    /**
     * Get script locator.
     * @return FileLocator
     */
    public function getFileLocator();
    
}
