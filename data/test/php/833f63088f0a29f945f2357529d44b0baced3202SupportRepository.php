<?
    namespace Znaika\FrontendBundle\Repository\Communication\Support;

    use Znaika\FrontendBundle\Repository\BaseRepository;
    use Znaika\FrontendBundle\Entity\Communication\Support;

    class SupportRepository extends BaseRepository implements ISupportRepository
    {
        /**
         * @var ISupportRepository
         */
        protected $dbRepository;

        /**
         * @var ISupportRepository
         */
        protected $redisRepository;

        public function __construct($doctrine)
        {
            $redisRepository = new SupportRedisRepository();
            $dbRepository    = $doctrine->getRepository('ZnaikaFrontendBundle:Communication\Support');

            $this->setRedisRepository($redisRepository);
            $this->setDBRepository($dbRepository);
        }

        /**
         * @param Support $support
         *
         * @return bool
         */
        public function save(Support $support)
        {
            $this->redisRepository->save($support);
            $success = $this->dbRepository->save($support);

            return $success;
        }
    }