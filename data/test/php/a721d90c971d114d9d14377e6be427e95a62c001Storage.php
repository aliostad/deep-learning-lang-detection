<?php

namespace Akamon\OAuth2\Server\Domain;

use Akamon\OAuth2\Server\Domain\Model\AccessToken\AccessTokenRepositoryInterface;
use Akamon\OAuth2\Server\Domain\Model\Client\ClientRepositoryInterface;
use Akamon\OAuth2\Server\Domain\Model\RefreshToken\RefreshTokenRepositoryInterface;
use Akamon\OAuth2\Server\Domain\Model\Scope\ScopeRepositoryInterface;

class Storage
{
    private $clientRepository;
    private $accessTokenRepository;
    private $scopeRepository;
    private $refreshTokenRepository;

    public function __construct(ClientRepositoryInterface $clientRepository, AccessTokenRepositoryInterface $accessTokenRepository, ScopeRepositoryInterface $scopeRepository, RefreshTokenRepositoryInterface $refreshTokenRepository = null)
    {
        $this->clientRepository = $clientRepository;
        $this->accessTokenRepository = $accessTokenRepository;
        $this->scopeRepository = $scopeRepository;
        $this->refreshTokenRepository = $refreshTokenRepository;
    }

    public function getClientRepository()
    {
        return $this->clientRepository;
    }

    public function getAccessTokenRepository()
    {
        return $this->accessTokenRepository;
    }

    public function getScopeRepository()
    {
        return $this->scopeRepository;
    }

    public function hasRefreshTokenRepository()
    {
        return !is_null($this->refreshTokenRepository);
    }

    public function getRefreshTokenRepository()
    {
        if (is_null($this->refreshTokenRepository)) {
            throw new \RuntimeException('There is no refresh token repository.');
        }

        return $this->refreshTokenRepository;
    }
}
