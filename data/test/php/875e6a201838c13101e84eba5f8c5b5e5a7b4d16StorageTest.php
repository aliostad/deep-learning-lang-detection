<?php

namespace Akamon\OAuth2\Server\Domain\Tests;

use Akamon\OAuth2\Server\Domain\Storage;

class StorageTest extends OAuth2TestCase
{
    private $clientRepository;
    private $accessTokenRepository;
    private $scopeRepository;
    private $refreshTokenRepository;

    protected function setUp()
    {
        $this->clientRepository = $this->mock('Akamon\OAuth2\Server\Domain\Model\Client\ClientRepositoryInterface');
        $this->accessTokenRepository = $this->mock('Akamon\OAuth2\Server\Domain\Model\AccessToken\AccessTokenRepositoryInterface');
        $this->scopeRepository = $this->mock('Akamon\OAuth2\Server\Domain\Model\Scope\ScopeRepositoryInterface');
        $this->refreshTokenRepository = $this->mock('Akamon\OAuth2\Server\Domain\Model\RefreshToken\RefreshTokenRepositoryInterface');
    }

    public function testConstructionMin()
    {
        $storage = new Storage($this->clientRepository, $this->accessTokenRepository, $this->scopeRepository);

        $this->assertSame($this->clientRepository, $storage->getClientRepository());
        $this->assertSame($this->accessTokenRepository, $storage->getAccessTokenRepository());
        $this->assertSame($this->scopeRepository, $storage->getScopeRepository());
        $this->assertFalse($storage->hasRefreshTokenRepository());
    }

    public function testConstructionFull()
    {
        $storage = new Storage($this->clientRepository, $this->accessTokenRepository, $this->scopeRepository, $this->refreshTokenRepository);

        $this->assertSame($this->clientRepository, $storage->getClientRepository());
        $this->assertSame($this->accessTokenRepository, $storage->getAccessTokenRepository());
        $this->assertSame($this->scopeRepository, $storage->getScopeRepository());
        $this->assertSame($this->refreshTokenRepository, $storage->getRefreshTokenRepository());
        $this->assertTrue($storage->hasRefreshTokenRepository());
    }

    /**
     * @expectedException \RuntimeException
     */
    public function testGetRefreshTokenRepositoryThrowsAnExceptionIfThereIsNoRefreshTokenRepository()
    {
        $storage = new Storage($this->clientRepository, $this->accessTokenRepository, $this->scopeRepository);
        $storage->getRefreshTokenRepository();
    }
}
