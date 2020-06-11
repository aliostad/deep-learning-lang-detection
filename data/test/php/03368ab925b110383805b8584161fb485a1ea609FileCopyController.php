<?php

/**
 * @package Vidola
 */
namespace Vidola\Controller;

use Vidola\Config\CommandLineConfig;
use Vidola\Util\FileCopy;

/**
 * @package Vidola
 */
class FileCopyController
{
    private $fileCopy;

    public function __construct(FileCopy $fileCopy)
    {
        $this->fileCopy = $fileCopy;
    }

    public function copyFiles(CommandLineConfig $config)
    {
        $this->fileCopy->copy(
            dirname($config->getTemplate()),
            $config->getTargetDir(),
            $config->getCopyExcludedFiles(),
            $config->getCopyIncludedFiles()
        );
    }
}
