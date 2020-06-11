<?php
namespace Quiz\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class QuizRoundControllerFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $services = $serviceLocator->getServiceLocator();

        /** @var \Quiz\Service\QuizRound $quizRoundService */
        $quizRoundService = $services->get('Quiz\Service\QuizRound');
        
        return new QuizRoundController(
            $quizRoundService
        );
    }
}
