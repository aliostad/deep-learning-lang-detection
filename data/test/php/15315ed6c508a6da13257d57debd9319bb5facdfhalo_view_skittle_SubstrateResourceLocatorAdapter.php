<?php

require_once('skittle_IResourceLocator.php');
require_once('substrate_IResourceLocator.php');

class halo_view_skittle_SubstrateResourceLocatorAdapter implements skittle_IResourceLocator {
    
    /**
     * Substrate resource locator
     * Enter description here ...
     * @var substrate_IResourceLocator
     */
    protected $resourceLocator;
    
    /**
     * Constructor
     * @param $resourceLocator
     */
    public function __construct(substrate_IResourceLocator $resourceLocator) {
        $this->resourceLocator = $resourceLocator;
    }
    
    /**
     * Attempt to find a target
     * @param $target
     * @param $realPath
     */
    public function find($target, $realPath = false) {
        return $this->resourceLocator->find($target, $realPath);
    }
    
}