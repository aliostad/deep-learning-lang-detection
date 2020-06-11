<?php
namespace Famelo\Soup\Typo3\Ingredients;

use Famelo\Archi\ComposerFacade;
use Famelo\Archi\Php\ClassFacade;
use Famelo\Archi\Typo3\ControllerFacade;
use Famelo\Soup\Core\Ingredients\AbstractIngredient;
use Famelo\Archi\Utility\Path;
use Famelo\Archi\Utility\String;
use Symfony\Component\Finder\Finder;

/*
 * This file belongs to the package "Famelo Soup".
 * See LICENSE.txt that was shipped with this package.
 */

class Controller extends AbstractIngredient {

	/**
	 * @var string
	 */
	public $name;

	/**
	 * @var ClassFacade
	 */
	public $facade;

	/**
	 * @var string
	 */
	protected $filepath;

	public function __construct($filepath = NULL) {
		$this->facade = new ControllerFacade($filepath);
		$this->name = String::cutSuffix($this->facade->name, 'Controller');
		$this->filepath = $filepath;
	}

	public static function getInstances() {
		$finder = new Finder();
		$files = $finder->files()->in('.')->path('Classes/Controller/')->name('*Controller.php');
		$instances = array();
		foreach ($files as $file) {
			$instances[] = new Controller($file->getRealPath());
		}
		return $instances;
	}

	public function getArguments() {
		return array($this->filepath);
	}

	public function getFilepath() {
		return $this->filepath;
	}

	public function getActions() {
		$actions = array();
		foreach ($this->facade->getMethods() as $method) {
			if (!String::endsWith($method->getName(), 'Action')) {
				continue;
			}
			$actions[$method->getName()] = $method;
		}
		return $actions;
	}

	public function remove($arguments) {
		$this->facade->remove();
	}

	public function save($arguments) {
		$this->facade->name = $arguments['name'];

		$composer = new ComposerFacade('composer.json');
		$this->facade->namespace = $composer->getNamespace() . 'Controller';;

		foreach ($arguments['actions'] as $action => $data) {
			if (isset($data['_remove'])) {
				$this->facade->removeAction($action);
			} else if ($this->facade->hasAction($action)) {
				if ($action !== $data['name']) {
					$this->facade->renameAction($action, $data['name']);
				}
			} else {
				$this->facade->addAction($data['name']);
			}
		}
		$this->facade->save();
	}
}
