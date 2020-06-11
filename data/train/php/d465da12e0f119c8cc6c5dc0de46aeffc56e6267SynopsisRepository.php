<?
    namespace Znaika\FrontendBundle\Repository\Lesson\Content;

    use Znaika\FrontendBundle\Repository\BaseRepository;
    use Znaika\FrontendBundle\Entity\Lesson\Content\Synopsis;

    class SynopsisRepository extends BaseRepository implements ISynopsisRepository
    {
        /**
         * @var ISynopsisRepository
         */
        protected $dbRepository;

        /**
         * @var ISynopsisRepository
         */
        protected $redisRepository;

        public function __construct($doctrine)
        {
            $redisRepository = new SynopsisRedisRepository();
            $dbRepository = $doctrine->getRepository('ZnaikaFrontendBundle:Lesson\Content\Synopsis');

            $this->setRedisRepository($redisRepository);
            $this->setDBRepository($dbRepository);
        }

        /**
         * @param Synopsis $synopsis
         *
         * @return mixed
         */
        public function save(Synopsis $synopsis)
        {

            $this->redisRepository->save($synopsis);
            $success = $this->dbRepository->save($synopsis);

            return $success;
        }

        /**
         * @param string $searchString
         *
         * @return array|null
         */
        public function getSynopsisesBySearchString($searchString)
        {
            $result = $this->redisRepository->getSynopsisesBySearchString($searchString);
            if ( empty($result) )
            {
                $result = $this->dbRepository->getSynopsisesBySearchString($searchString);
            }
            return $result;
        }
    }