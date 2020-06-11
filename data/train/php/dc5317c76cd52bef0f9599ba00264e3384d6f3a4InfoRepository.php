<?
    namespace Znaika\ProfileBundle\Repository\Ban;

    use Znaika\FrontendBundle\Repository\BaseRepository;
    use Znaika\ProfileBundle\Entity\Ban\Info;

    class InfoRepository extends BaseRepository implements IInfoRepository
    {
        /**
         * @var IInfoRepository
         */
        protected $dbRepository;

        /**
         * @var IInfoRepository
         */
        protected $redisRepository;

        public function __construct($doctrine)
        {
            $redisRepository = new InfoRedisRepository();
            $dbRepository    = $doctrine->getRepository('ZnaikaProfileBundle:Ban\Info');

            $this->setRedisRepository($redisRepository);
            $this->setDBRepository($dbRepository);
        }

        public function save(Info $info)
        {
            $this->redisRepository->save($info);
            $success = $this->dbRepository->save($info);

            return $success;
        }
    }