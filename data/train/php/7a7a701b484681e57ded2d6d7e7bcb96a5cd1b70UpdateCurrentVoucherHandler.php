<?php
namespace Gyman\Application\Handler;

use Gyman\Application\Command\UpdateCurrentVoucherCommand;
use Gyman\Application\Repository\MemberRepositoryInterface;
use Gyman\Application\Repository\VoucherRepositoryInterface;
use Gyman\Bundle\AppBundle\Repository\MemberRepository;
use Gyman\Bundle\AppBundle\Repository\VoucherRepository;
use Gyman\Domain\Member;
use Gyman\Domain\Voucher;

class UpdateCurrentVoucherHandler
{
    public $lastUpdatedData;
    
    /** @var  MemberRepository|MemberRepositoryInterface */
    private $memberRepository;

    /** @var  VoucherRepository|VoucherRepositoryInterface */
    private $voucherRepository;

    /**
     * UpdateCurrentVoucherHandler constructor.
     * @param MemberRepositoryInterface|MemberRepository $memberRepository
     * @param VoucherRepository|VoucherRepositoryInterface $voucherRepository
     */
    public function __construct($memberRepository, $voucherRepository)
    {
        $this->memberRepository = $memberRepository;
        $this->voucherRepository = $voucherRepository;
    }

    public function handle(UpdateCurrentVoucherCommand $command){
        $vouchers = $this->voucherRepository->findAllNotSetCurrentVouchers();
        $members = [];

        /** @var Voucher $voucher */
        foreach($vouchers as $voucher) {
            $member = $voucher->member();
            $member->setCurrentVoucher($voucher);
            $members[] = $member;
        }

        $this->memberRepository->save($members);

        $this->lastUpdatedData = $members;
    }
}