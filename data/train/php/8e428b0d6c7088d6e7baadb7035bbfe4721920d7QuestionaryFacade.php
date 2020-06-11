<?php

namespace Subscribo\TransactionPluginManager\Facades;

use Subscribo\RestCommon\Questionary;
use Subscribo\TransactionPluginManager\Interfaces\QuestionaryFacadeInterface;
use Subscribo\TransactionPluginManager\Traits\TransparentFacadeTrait;

/**
 * Class QuestionaryFacade
 *
 * @package Subscribo\TransactionPluginManager
 */
class QuestionaryFacade implements QuestionaryFacadeInterface
{
    use TransparentFacadeTrait;

    /** @var Questionary  */
    protected $instanceOfObjectBehindFacade;

    /**
     * @param Questionary $questionary
     */
    public function __construct(Questionary $questionary)
    {
        $this->instanceOfObjectBehindFacade = $questionary;
    }

    /**
     * @return Questionary
     */
    public function getQuestionaryInstance()
    {
        return $this->instanceOfObjectBehindFacade;
    }
}
