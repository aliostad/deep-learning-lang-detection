<?php
/*
 * This file is part of the Sergey Chernecov software.
 *
 * (c) 2014
 *
 * Do not care about any copyright or license.
 */

namespace Chernecov\Bundle\CartBundle\Traits;

/**
 * Embedded trait
 *
 * @author Sergey Chernecov <sergey.chernecov@gmail.com>
 */
trait EmbeddedTrait
{
    /**
     * Show embedded
     *
     * @var bool
     */
    private $showEmbedded = false;

    /**
     * Show embedded setter
     *
     * @param boolean $showEmbedded
     *
     * @return self
     */
    public function setShowEmbedded($showEmbedded)
    {
        $this->showEmbedded = (bool) $showEmbedded;
        return $this;
    }

    /**
     * Show embedded?
     *
     * @return boolean
     */
    public function showEmbedded()
    {
        return (bool) $this->showEmbedded;
    }
}