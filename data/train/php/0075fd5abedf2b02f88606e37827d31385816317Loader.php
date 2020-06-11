<?php

/**
 * Part of the Vermillion
 *
 * @author  Kilte Leichnam <nwotnbm@gmail.com>
 * @package Vermillion
 */

namespace Vermillion\Configuration\Loader;

use Symfony\Component\Config\FileLocatorInterface;

/**
 * Loader Class
 *
 * @package Vermillion\Configuration\Loader
 */
abstract class Loader extends \Symfony\Component\Config\Loader\Loader
{

    /**
     * @var FileLocatorInterface
     */
    protected $locator;

    /**
     * Constructor
     *
     * @param FileLocatorInterface $locator Locator
     *
     * @return self
     */
    public function __construct(FileLocatorInterface $locator)
    {
        $this->locator = $locator;
    }

}
