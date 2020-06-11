<?php

namespace Quaver\Core;

class Auth extends Facade
{
    protected static $facadeInstanceName = 'user';
    
    /**
     * {@inheritdoc}
     */
    public static function getFacadeInstanceName()
    {
        return static::$facadeInstanceName;
    }
    
    /**
     * Set the default guard the factory should serve.
     *
     * @param string $name
     */
    public static function shouldUse($name)
    {
        static::$facadeInstanceName = $name;
    }
    
    /**
     * Get the currently authenticated user
     *
     * @return \Quaver\Model\GuardUser
     */
    public static function user()
    {
        return static::resolveFacadeInstance(static::$facadeInstanceName)->user();
    }
    
    /**
     * login.
     *
     * @param \Quaver\App\Model\User $user
     * @param $remember default to false
     *
     * @return bool
     */
    public static function login($credentials, $remember = false)
    {
        return static::resolveFacadeInstance(static::$facadeInstanceName)->login($credentials, $remember);
    }
    
    /**
     * login once.
     *
     * @param \Quaver\App\Model\User $user
     *
     * @return bool
     */
    public static function loginOnce($credentials)
    {
        return static::resolveFacadeInstance(static::$facadeInstanceName)->loginOnce($credentials);
    }
    
    /**
     * Check if current user is logged.
     *
     * @return bool
     */
    public static function isLogged()
    {
        return static::resolveFacadeInstance(static::$facadeInstanceName)->isLogged();
    }
    
    /**
     * Check if current user is logged via "remember me" cookie.
     *
     * @return bool
     */
    public static function isLoggedViaRemember()
    {
        return static::resolveFacadeInstance(static::$facadeInstanceName)->isLoggedViaRemember();
    }
    
    /**
     * Destroys all data registered to a logged user.
     */
    public static function logout()
    {
        return static::resolveFacadeInstance(static::$facadeInstanceName)->logout();
    }
}