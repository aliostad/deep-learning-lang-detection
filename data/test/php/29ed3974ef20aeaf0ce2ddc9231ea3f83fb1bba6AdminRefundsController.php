<?php

use Acme\Payment\PaymentRepository;
use Acme\Refund\RefundRepository;
use Acme\Subscription\SubscriptionRepository;

class AdminRefundsController extends AdminBaseController {

    /**
     * @var PaymentRepository
     */
    private $paymentRepository;
    /**
     * @var SubscriptionRepository
     */
    private $subscriptionRepository;
    /**
     * @var RefundRepository
     */
    private $refundRepository;


    /**
     * @param PaymentRepository $paymentRepository
     * @param SubscriptionRepository $subscriptionRepository
     * @param RefundRepository $refundRepository
     */
    function __construct(PaymentRepository $paymentRepository, SubscriptionRepository $subscriptionRepository, RefundRepository $refundRepository)
    {
        $this->paymentRepository = $paymentRepository;
        $this->subscriptionRepository = $subscriptionRepository;
        $this->refundRepository = $refundRepository;
        parent::__construct();
    }

    public function index()
    {
        $status = Input::get('status');
        $type   = Input::get('type');

        if ( !isset($type) ) {
            $type = 'refund';
        }

        if ( $type == 'refund' ) {
            if ( isset($status) ) {
                $refunds = $this->refundRepository->getAllByStatus($status, ['user', 'payment.payable.event']);
            } else {
                $refunds = $this->refundRepository->getAll(['user', 'payment.payable.event']);
            }
        }

        $this->render('admin.refunds.index', compact('refunds','type','status'));
    }

}

