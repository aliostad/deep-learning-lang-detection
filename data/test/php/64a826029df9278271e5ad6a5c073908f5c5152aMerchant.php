<?php

/*
 * This file is part of the PaymentSuite package.
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * Feel free to edit as you please, and have fun.
 *
 * @author Marc Morera <yuhu@mmoreram.com>
 */

namespace PaymentSuite\PayUBundle\Model;

/**
 * Merchant Model
 */
class Merchant
{
    /**
     * @var string
     *
     * apiLogin
     */
    protected $apiLogin;

    /**
     * @var string
     *
     * apiKey
     */
    protected $apiKey;

    /**
     * Sets ApiKey
     *
     * @param string $apiKey ApiKey
     *
     * @return Merchant Self object
     */
    public function setApiKey($apiKey)
    {
        $this->apiKey = $apiKey;

        return $this;
    }

    /**
     * Get ApiKey
     *
     * @return string ApiKey
     */
    public function getApiKey()
    {
        return $this->apiKey;
    }

    /**
     * Sets ApiLogin
     *
     * @param string $apiLogin ApiLogin
     *
     * @return Merchant Self object
     */
    public function setApiLogin($apiLogin)
    {
        $this->apiLogin = $apiLogin;

        return $this;
    }

    /**
     * Get ApiLogin
     *
     * @return string ApiLogin
     */
    public function getApiLogin()
    {
        return $this->apiLogin;
    }
}
