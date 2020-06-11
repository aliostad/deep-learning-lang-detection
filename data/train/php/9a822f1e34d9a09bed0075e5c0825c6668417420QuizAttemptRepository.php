<?
    namespace Znaika\FrontendBundle\Repository\Lesson\Content\Stat;

    use Znaika\FrontendBundle\Entity\Lesson\Content\Stat\QuizAttempt;
    use Znaika\FrontendBundle\Repository\BaseRepository;

    class QuizAttemptRepository extends BaseRepository implements IQuizAttemptRepository
    {
        /**
         * @var IQuizAttemptRepository
         */
        protected $dbRepository;

        /**
         * @var IQuizAttemptRepository
         */
        protected $redisRepository;

        public function __construct($doctrine)
        {
            $redisRepository = new QuizAttemptRedisRepository();
            $dbRepository    = $doctrine->getRepository('ZnaikaFrontendBundle:Lesson\Content\Stat\QuizAttempt');

            $this->setRedisRepository($redisRepository);
            $this->setDBRepository($dbRepository);
        }

        public function save(QuizAttempt $quizAttempt)
        {
            $this->redisRepository->save($quizAttempt);
            $result = $this->dbRepository->save($quizAttempt);

            return $result;
        }

        public function getUserQuizAttempt($userId, $quizId)
        {
            $result = $this->redisRepository->getUserQuizAttempt($userId, $quizId);
            if (is_null($result))
            {
                $result = $this->dbRepository->getUserQuizAttempt($userId, $quizId);
            }

            return $result;
        }
    }