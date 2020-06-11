<?php

namespace Gamma\CustomerReview\CustomerReviewBundle\Traits;

/**
 * Set CustomerReviewManager trait
 *
 * @author Evgen Kuzmin <jekccs@gmail.com>
 */
trait SetCustomerReviewManagerTrait
{
    /**
     * @DI\Inject("gamma.customer_review.manager")
     * @var \Gamma\CustomerReview\CustomerReviewsBundle\Services\CustomerReviewManager $customerReviewManager
     */
    protected $customerReviewManager;
    
    /**
     * @param \Gamma\CustomerReview\CustomerReviewsBundle\Services\CustomerReviewManager $customerReviewManager
     */
    public function setCustomerReviewManager($customerReviewManager)
    {
        $this->customerReviewManager = $customerReviewManager;
    }
}
