<?php

namespace Martha\Controller;

use Martha\Core\Domain\Repository\LogRepositoryInterface;
use Zend\Mvc\Controller\AbstractActionController;

/**
 * Class ErrorController
 * @package Martha\Controller
 */
class ErrorController extends AbstractActionController
{
    /**
     * @var \Martha\Core\Domain\Repository\LogRepositoryInterface
     */
    protected $repository;

    /**
     * @param LogRepositoryInterface $repository
     */
    public function __construct(LogRepositoryInterface $repository)
    {
        $this->repository = $repository;
    }

    /**
     * @return array
     */
    public function indexAction()
    {
        $errors = $this->repository->getBy([], ['created' => 'DESC'], 20);

        $this->repository->clearUnreadLogs();

        return [
            'pageTitle' => 'Error Log',
            'errors' => $errors
        ];
    }

    /**
     * Clear the errors in the table.
     */
    public function clearAction()
    {
        $this->repository->deleteAll();

        $this->redirect()->toRoute('errors');
    }
}
