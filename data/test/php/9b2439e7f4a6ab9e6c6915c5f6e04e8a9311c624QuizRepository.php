<?
    namespace Znaika\FrontendBundle\Repository\Lesson\Content\Attachment;

    use Znaika\FrontendBundle\Entity\Lesson\Content\Attachment\Quiz;
    use Znaika\FrontendBundle\Entity\Lesson\Content\Attachment\VideoAttachment;
    use Znaika\FrontendBundle\Repository\BaseRepository;

    class QuizRepository extends BaseRepository implements IQuizRepository
    {
        /**
         * @var IQuizRepository
         */
        protected $dbRepository;

        /**
         * @var IQuizRepository
         */
        protected $redisRepository;

        public function __construct($doctrine)
        {
            $redisRepository = new QuizRedisRepository();
            $dbRepository    = $doctrine->getRepository('ZnaikaFrontendBundle:Lesson\Content\Attachment\Quiz');

            $this->setRedisRepository($redisRepository);
            $this->setDBRepository($dbRepository);
        }

        public function save(Quiz $quiz)
        {
            $this->redisRepository->save($quiz);
            $result = $this->dbRepository->save($quiz);

            return $result;
        }

        public function getOneByVideoId($videoId)
        {
            $result = $this->redisRepository->getOneByVideoId($videoId);
            if (is_null($result))
            {
                $result = $this->dbRepository->getOneByVideoId($videoId);
            }

            return $result;
        }
    }