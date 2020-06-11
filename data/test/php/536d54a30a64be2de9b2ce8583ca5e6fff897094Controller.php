<?php
namespace Wise\Controller;

use Wise\Component\Component;

/**
 * Class \Wise\Controller\Controller
 * 
 * This class must be extended by the controllers of apps
 *
 * @author gdievart <dievartg@gmail.com>
 */
abstract class Controller extends Component
{
    /**
     * References to the repositories loaded
     * 
     * @var array \Wise\Repository\Repository
     */
    protected $repositoryLoaded = array();

    /**
     * Return repositories
     *
     * @param  string     $repository The classname of the repository to load
     * @return \Wise\Repository\Repository
     */
    public function getRepository($classname)
    {
        if (empty($this->repositoryLoaded[$classname])) {
            if (!class_exists($classname, true) || !is_subclass_of($classname, '\Wise\Repository\Repository')) {
                throw new Exception('The repository "'.$classname.'" is not valid', 0);
            }
            $repository = new \ReflectionClass($classname);
            $this->repositoryLoaded[$classname] = $repository->newInstance();
        }

        return $this->repositoryLoaded[$classname];
    }
}
