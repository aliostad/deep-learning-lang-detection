<?php namespace App\Jobs\Customer;

use App\Domain\Customer\CustomerId;
use App\Domain\Customer\CustomerRepository;
use Illuminate\Contracts\Bus\SelfHandling;
use Singularity\Foundation\Jobs\Job;

/**
 * Update Customer Subscription Status Job.
 *
 * @author  macku99
 * @version 1.0
 * @package Singularity
 */
class UpdateSubscriptionStatus extends Job implements SelfHandling
{

    /**
     * @var CustomerId
     */
    protected $id;

    /**
     * @var bool
     */
    protected $subscribed;

    /**
     * @param string $customerId
     * @param bool   $subscribed
     */
    public function __construct($customerId, $subscribed)
    {
        $this->id = CustomerId::make($customerId);
        $this->subscribed = $subscribed ? true : false;
    }

    /**
     * Execute the job.
     *
     * @param CustomerRepository $customerRepository
     */
    public function handle(CustomerRepository $customerRepository)
    {
        $customer = $customerRepository->get($this->id);
        if ($this->subscribed) {
            $customer->subscribe();
        } else {
            $customer->unsubscribe();
        }

        $customerRepository->commit();
    }

}