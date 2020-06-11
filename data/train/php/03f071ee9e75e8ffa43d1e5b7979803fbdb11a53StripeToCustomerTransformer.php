<?php

namespace SD\StripeBundle\Transformer;

use SD\StripeBundle\Factory\StripeFactory;
use SD\StripeBundle\Stripe\Customer;
use Stripe\Customer as StripeCustomer;

/**
 * Class StripeToCustomerTransformer
 *
 * @author Sylvain Deloux <github@eax.fr>
 *
 * @package SD\StripeBundle\Transformer
 */
class StripeToCustomerTransformer
{
    /**
     * @param StripeCustomer $stripeCustomer
     *
     * @return Customer
     */
    public function transform(StripeCustomer $stripeCustomer)
    {
        $customer = new Customer();

        $createdAt = new \DateTime($stripeCustomer['created']);

        $customer->setId($stripeCustomer['id']);
        $customer->setCreatedAt($createdAt);
        $customer->setDescription($stripeCustomer['description']);
        $customer->setEmail($stripeCustomer['email']);
        $customer->setAccountBalance(StripeFactory::convertStripeAmountToFloat($stripeCustomer['account_balance']));
        $customer->setCurrency($stripeCustomer['currency']);
        $customer->setDelinquent($stripeCustomer['delinquent']);
        $customer->setLiveMode($stripeCustomer['livemode']);
        $customer->setMetadata($stripeCustomer['metadata']->__toArray());

        return $customer;
    }
}
