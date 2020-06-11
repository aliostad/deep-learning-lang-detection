<?php

namespace Butterfly\Component\DI\Tests\Compiler\Annotation\Stub\Autowired\Example7;

use Butterfly\Component\DI\Tests\Compiler\Annotation\Stub\Autowired\Example7\DirA\InnerService;

/**
 * @service service.base
 */
class Service
{
    /**
     * @var InnerService
     */
    protected $innerService;

    /**
     * @autowired ["service.inner"]
     *
     * @param InnerService $innerService
     */
    public function __construct(InnerService $innerService)
    {
        $this->innerService = $innerService;
    }
}
