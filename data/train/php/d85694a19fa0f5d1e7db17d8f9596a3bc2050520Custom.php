<?php

namespace Inchoo\UiExamples\CustomerData;

class Custom implements \Magento\Customer\CustomerData\SectionSourceInterface
{
    /**
     * @var CurrentCustomer
     */
    protected $currentCustomer;

    /**
     * Customer constructor.
     * @param \Magento\Customer\Helper\Session\CurrentCustomer $currentCustomer
     */
    public function __construct(
        \Magento\Customer\Helper\Session\CurrentCustomer $currentCustomer
    ) {
        $this->currentCustomer = $currentCustomer;
    }

    /**
     * {@inheritdoc}
     */
    public function getSectionData()
    {
        if ($this->currentCustomer->getCustomerId()) {
           $email = $this->currentCustomer->getCustomer()->getEmail();
        } else {
            $email = '';
        }

        return [
            'hello'  => 'Hello world !',
            'email' => $email
        ];
    }
}
