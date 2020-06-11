<?php
namespace Acelaya\QrCode\Service;

/**
 * Class QrCodeServiceAwareTrait
 * @author Alejandro Celaya Alastrué
 * @link http://www.alejandrocelaya.com
 */
trait QrCodeServiceAwareTrait
{
    /**
     * @var QrCodeServiceInterface
     */
    protected $qrCodeService;

    /**
     * @param QrCodeServiceInterface $qrCodeService
     * @return void
     */
    public function setQrCodeService(QrCodeServiceInterface $qrCodeService)
    {
        $this->qrCodeService = $qrCodeService;
    }

    /**
     * @return QrCodeServiceInterface
     */
    public function getQrCodeService()
    {
        return $this->qrCodeService;
    }
}
