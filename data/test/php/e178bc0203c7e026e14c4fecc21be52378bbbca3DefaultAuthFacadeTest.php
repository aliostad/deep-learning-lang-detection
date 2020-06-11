<?php
use STS\Core;
use STS\TestUtilities\UserTestCase;
use STS\Core\Api\DefaultAuthFacade;

class DefaultAuthFacadeTest extends UserTestCase
{
    /**
     * @test
     */
    public function validGetTempPassword()
    {
        $facade = $this->getFacadeWithMockedDeps();
        $tempPassword = $facade->generateTemporaryPassword();
        $this->assertRegExp('/^[a-z0-9]{8}$/i', $tempPassword);
    }

    private function getFacadeWithMockedDeps()
    {
        $userRepo = \Mockery::mock('STS\Core\User\MongoUserRepository');
        return new DefaultAuthFacade($userRepo);
    }
}
