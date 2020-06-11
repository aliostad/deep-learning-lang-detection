<?php
namespace Ppantelakis\BarCode\Service;

/**
 * Class BarCodeServiceAwareTrait
 * @author Ppantelakis Panagiotis
 * @link http://www.pantelakis.org
 */
trait BarCodeServiceAwareTrait
{
    /**
     * @var BarCodeServiceInterface
     */
    protected $barCodeService;

    /**
     * @param BarCodeServiceInterface $barCodeService
     * @return void
     */
    public function setBarCodeService(BarCodeServiceInterface $barCodeService)
    {
        $this->barCodeService = $barCodeService;
    }

    /**
     * @return BarCodeServiceInterface
     */
    public function getBarCodeService()
    {
        return $this->barCodeService;
    }
}
