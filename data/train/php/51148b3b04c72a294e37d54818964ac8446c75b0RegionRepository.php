<?php
    namespace Znaika\ProfileBundle\Repository;

    use Znaika\FrontendBundle\Repository\BaseRepository;
    use Znaika\ProfileBundle\Entity\Region;

    class RegionRepository extends BaseRepository implements IRegionRepository
    {
        /**
         * @var IRegionRepository
         */
        protected $dbRepository;

        /**
         * @var IRegionRepository
         */
        protected $redisRepository;

        public function __construct($doctrine)
        {
            $redisRepository = new RegionRedisRepository();
            $dbRepository    = $doctrine->getRepository('ZnaikaProfileBundle:Region');

            $this->setRedisRepository($redisRepository);
            $this->setDBRepository($dbRepository);
        }

        /**
         * @param Region $region
         *
         * @return bool
         */
        public function save(Region $region)
        {
            $this->redisRepository->save($region);
            $success = $this->dbRepository->save($region);

            return $success;
        }

        /**
         * @param Region $region
         *
         * @return bool
         */
        public function delete(Region $region)
        {
            $this->redisRepository->delete($region);
            $success = $this->dbRepository->delete($region);

            return $success;
        }

        /**
         * @return Region[]
         */
        public function getAll()
        {
            $result = $this->redisRepository->getAll();
            if (is_null($result))
            {
                $result = $this->dbRepository->getAll();
            }

            return $result;
        }
    }