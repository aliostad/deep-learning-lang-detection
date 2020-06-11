<?php
/**
 * User: mcsere
 * Date: 10/29/14
 * Time: 5:26 PM
 * Contact: miki@softwareengineer.ro
 */

namespace Transp\Service\Traits;


use App;
use Transp\repositories\IAutoCompleteRepository;
use Transp\Repositories\ITaskRepository;
use Transp\Repositories\Structure\ICMSRepository;
use Transp\Repositories\Structure\ILangRepository;
use Transp\Repositories\Structure\IPageRepository;
use Transp\Repositories\Structure\IUserRepository;

trait RepoTrait
{

    /**
     * @var ILangRepository
     */
    private $langRepository;
    /**
     * @var IUserRepository
     */
    private $userRepository;
    /**
     * @var ICMSRepository
     */
    private $cmsRepository;
    /**
     * @var IPageRepository
     */
    private $pageRepository;

    /**
     * @var ITaskRepository
     */
    private $taskRepository;


    /**
     * @var IAutoCompleteRepository
     */
    private $autoCompleteRepository;


    /**
     * @return \Transp\Repositories\Structure\ICMSRepository
     */
    protected function getCmsRepository()
    {
        if (!isset($this->cmsRepository)) {
            $this->cmsRepository = App::make("Transp\Repositories\Structure\ICMSRepository");
        }
        return $this->cmsRepository;
    }

    /**
     * @return \Transp\Repositories\Structure\ILangRepository
     */
    protected function getLangRepository()
    {
        if (!isset($this->langRepository)) {
            $this->langRepository = App::make("Transp\Repositories\Structure\ILangRepository");
        }
        return $this->langRepository;
    }

    /**
     * @return \Transp\Repositories\Structure\IPageRepository
     */
    protected function getPageRepository()
    {
        if (!isset($this->pageRepository)) {
            $this->pageRepository = App::make("Transp\Repositories\Structure\IPageRepository");
        }
        return $this->pageRepository;
    }


    /**
     * @return \Transp\Repositories\Structure\IUserRepository
     */
    protected function getUserRepository()
    {
        if (!isset($this->userRepository)) {
            $this->userRepository = App::make("Transp\Repositories\Structure\IUserRepository");
        }
        return $this->userRepository;
    }

    protected function getTaskRepository()
    {
        if (!isset($this->taskRepository)) {
            $this->taskRepository = App::make("Transp\Repositories\ITaskRepository");
        }
        return $this->taskRepository;
    }

    protected function getAutoCompleteRepository()
    {
        if (!isset($this->autoCompleteRepository)) {
            $this->autoCompleteRepository = App::make("Transp\Repositories\IAutoCompleteRepository");
        }
        return $this->autoCompleteRepository;
    }


}