<?php
/**
 * Service
 *
 * @author Shinichiro Yuki <sinycourage@gmail.com>
 */
namespace Sedy\PAApi\Request\Url\Parameter\Service;

use Sedy\PAApi\Request\Url\Parameter\ParameterInterface;

/**
 * Service
 *
 * @author Shinichiro Yuki <sinycourage@gmail.com>
 */
class Service implements ServiceInterface, ParameterInterface
{
    /**
     * @var string
     */
    private $service;

    /**
     * @param string $service
     */
    public function __construct($service)
    {
        $this->assertString($service);

        $this->service = $service;
    }

    /**
     * @param mixed $service
     *
     * @return void
     * @throws InvalidServiceException
     */
    private function assertString($service)
    {
        if (is_string($service)) {
            return;
        }
        throw new InvalidServiceException(gettype($service));
    }
}
