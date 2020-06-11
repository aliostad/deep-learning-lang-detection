<?php
/**
 * Created by PhpStorm.
 * User: melodic
 * Date: 04.10.16
 * Time: 16:43
 */

namespace App\Infrastructure\Service;


use App\Application\Service\AuthServiceInterface;
use Aura\Auth\Auth;
use Aura\Auth\Service\LoginService;
use Aura\Auth\Service\LogoutService;
use Aura\Auth\Service\ResumeService;
use Aura\Auth\Status;

class AuraAuthService implements AuthServiceInterface
{

    /**
     * @var Auth
     */
    private $auth;

    /**
     * @var LoginService
     */
    private $loginService;

    /**
     * @var LogoutService
     */
    private $logoutService;

    /**
     * @var ResumeService
     */
    private $resumeService;

    public function __construct(Auth $auth, LoginService $loginService, LogoutService $logoutService, ResumeService $resumeService)
    {
        $this->auth = $auth;
        $this->loginService = $loginService;
        $this->logoutService = $logoutService;
        $this->resumeService = $resumeService;
    }

    public function login($login, $password)
    {
        $this->loginService->login($this->auth, [
            'username' => $login,
            'password' => $password
        ]);
        return !$this->isGuest();
    }


    /**
     * @return bool
     */
    public function isGuest()
    {
        return !$this->auth->isValid();
    }

    public function logout()
    {
         $this->logoutService->logout($this->auth);
    }
}