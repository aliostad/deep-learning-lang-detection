<?php

namespace SpiffyAuthorize\Service;

trait AuthorizeServiceAwareTrait
{
    /**
     * @var AuthorizeServiceInterface
     */
    protected $authorizeService;

    /**
     * @param AuthorizeServiceInterface $authorizeService
     * @return $this
     */
    public function setAuthorizeService(AuthorizeServiceInterface $authorizeService)
    {
        $this->authorizeService = $authorizeService;
        return $this;
    }

    /**
     * @return AuthorizeServiceInterface
     */
    public function getAuthorizeService()
    {
        return $this->authorizeService;
    }
}