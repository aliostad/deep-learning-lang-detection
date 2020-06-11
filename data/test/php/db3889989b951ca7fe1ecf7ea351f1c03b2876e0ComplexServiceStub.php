<?php

namespace Butterfly\Component\DI\Tests\Stubs;

/**
 * @author Marat Fakhertdinov <marat.fakhertdinov@gmail.com>
 */
class ComplexServiceStub
{
    public $internalService;

    public function __construct(ServiceStub $internalService = null)
    {
        $this->internalService = $internalService;
    }

    public function setInternalService(ServiceStub $internalService)
    {
        $this->internalService = $internalService;
    }

    public function getInternalService()
    {
        return $this->internalService;
    }
}
