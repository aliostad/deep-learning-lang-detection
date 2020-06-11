<?
    namespace Znaika\FrontendBundle\Repository;

    class BaseRepository
    {
        protected $dbRepository;
        protected $redisRepository;

        /**
         * @param $dbRepository
         */
        protected function setDBRepository($dbRepository)
        {
            $this->dbRepository = $dbRepository;
        }

        /**
         * @param $redisRepository
         */
        protected function setRedisRepository($redisRepository)
        {
            $this->redisRepository = $redisRepository;
        }
    }
