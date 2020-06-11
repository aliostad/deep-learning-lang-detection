<?php

use PA\AuthFacade;


class AuthTest extends PHPUnit_Framework_TestCase
{

    /**
     * @var AuthFacade
     */
    private $facade;



    public function setUp()
    {
        $this->facade = new AuthFacade();
    }


    public function testLoginWithFacade()
    {
        // Check user is not auth
        $this->assertFalse($this->facade->check());


        $username = 'username_test';
        $password = 'password_test';

        // Login
        $this->facade->login($username, $password);

        // User is logged in
        $this->assertTrue($this->facade->check());

        // Get user profile
        $profile = $this->facade->user();

        $this->assertArrayHasKey('username', $profile);
        $this->assertArrayHasKey('password', $profile);

        $this->assertEquals($username, $profile['username']);
        $this->assertEquals($password, $profile['password']);


        // Logout
        $this->facade->logout();

        $this->assertFalse($this->facade->check());
    }

}