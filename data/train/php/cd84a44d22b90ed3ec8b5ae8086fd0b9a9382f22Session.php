<?php

    /**
     *  Bu Sınıf GemFramework'de Session sınıfı ile yapılan işlemlerin static olarak yapılmasını
     *  sağlamak için oluşturulmuştur.
     *
     * @authot vahitserifsaglam <vahit.serif119@gmail.com>
     */

    namespace Gem\Components\Facade;

    use Gem\Components\Patterns\Facade;

    class Session extends Facade
    {

        /**
         * @return string
         */
        protected static function getFacadeClass()
        {
            return 'Session';
        }
    }