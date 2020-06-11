<?php

/**
 * =============================================================================
 * @file       Commons/Light/View/Template/TemplateLocatorAwareInterface.php
 * @author     Lukasz Cepowski <lukasz@cepowski.com>
 * 
 * @copyright  PHP Commons
 *             Copyright (C) 2009-2013 PHP Commons Contributors
 *             All rights reserved.
 *             www.phpcommons.com
 * =============================================================================
 */

namespace Commons\Light\View\Template;

interface TemplateLocatorAwareInterface
{
    
    /**
     * Set template locator.
     * @param TemplateLocator $locator
     * @return TemplateLocatorAwareInterface
     */
    public function setTemplateLocator(TemplateLocator $locator);
    
    /**
     * Get template locator.
     * @return TemplateLocator
     */
    public function getTemplateLocator();
    
}
