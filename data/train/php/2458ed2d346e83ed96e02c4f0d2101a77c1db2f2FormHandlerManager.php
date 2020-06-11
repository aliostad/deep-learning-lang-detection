<?php

namespace Mitom\Bundle\FormHandlerBundle;


use Mitom\Bundle\FormHandlerBundle\Exception\FormHandlerNotFoundException;
use Mitom\Bundle\FormHandlerBundle\Handler\FormHandlerInterface;
use Symfony\Component\Form\FormTypeInterface;

class FormHandlerManager
{
    /**
     * @var FormHandlerInterface[]
     */
    private $handlers = [];

    /**
     * @param FormHandlerInterface $handler
     */
    public function addHandler(FormHandlerInterface $handler)
    {
        $type = $handler->getType() instanceof FormTypeInterface ? $handler->getType()->getName() : $handler->getType();
        $this->handlers[$type] = $handler;
    }

    /**
     * @param $type
     *
     * @return FormHandlerInterface
     * @throws FormHandlerNotFoundException
     */
    public function getHandler($type) {
        if (isset($this->handlers[$type])) {
            return $this->handlers[$type];
        }

        throw new FormHandlerNotFoundException($type);
    }
} 