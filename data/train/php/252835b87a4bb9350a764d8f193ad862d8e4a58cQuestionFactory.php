<?php
namespace Quiz\Form;

use Quiz\Form\Question as QuestionForm;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class QuestionFactory implements FactoryInterface
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

        /** @var \Doctrine\ORM\EntityManagerInterface $em */
        $em = $services->get('Doctrine\ORM\EntityManager');

        /** @var \Quiz\Service\Category $categoryService */
        $categoryService = $services->get('Quiz\Service\Category');

        /** @var \Quiz\Service\Tag $tagService */
        $tagService = $services->get('Quiz\Service\Tag');
        
        return new QuestionForm(
            $em,
            $categoryService,
            $tagService
        );
    }
}
