<?php

namespace Indent\Business;

/**
 * Class IndentPriorityManager
 *
 * PHP Version 5
 *
 * @category  PHP
 * @package   Indent\Business
 * @author    Simplicity Trade GmbH <it@simplicity.ag>
 * @copyright 2014-2017 Simplicity Trade GmbH
 * @license   Proprietary http://www.simplicity.ag
 */
class IndentPriorityManager
{
    /** @var IndentFacade */
    protected $indentFacade;

    /**
     * IndentPriorityManager constructor.
     *
     * @param IndentFacade $indentFacade
     */
    public function __construct(IndentFacade $indentFacade)
    {
        $this->indentFacade = $indentFacade;
    }
}