<?php
namespace Famelo\Archi\Tests\Functional\Typo3;

use Famelo\Archi\Typo3\ControllerFacade;
use org\bovigo\vfs\vfsStream;

/**
 * Class ModelFacadeTest
 */
class ModelFacadeTest extends \PHPUnit_Framework_TestCase {

	/**
	 * @return void
	 */
	public static function setUpBeforeClass() {
		vfsStream::setup('root');
	}

	public function mockController() {
		file_put_contents(vfsStream::url('root/FooController.php'), '<?php
			namespace Foo\Bar\Controller;

			class FooController extends \TYPO3\CMS\Extbase\Mvc\Controller\ActionController {

			    /**
			     * @return void
			     */
			    public function indexAction() {
			    }

			    /**
			     * @return void
			     */
			    public function showAction() {
			    }

			}
		');
	}

	/**
	 * @test
	 */
	public function readController() {
		$this->mockController();

		$facade = new ControllerFacade(vfsStream::url('root/FooController.php'));
		$this->assertEquals('FooController', $facade->name);
		$this->assertEquals('Foo\Bar\Controller', $facade->namespace);
		$this->assertEquals(array(
			'index', 'show'
		), $facade->actions);
		$this->assertTrue($facade->hasAction('index'));
		$this->assertFalse($facade->hasAction('bar'));
	}

	/**
	 * @test
	 */
	public function changeController() {
		$this->mockController();
		$facade = new ControllerFacade(vfsStream::url('root/FooController.php'));
		$facade->name = 'BarController';
		$facade->namespace = 'Foo\Baz\Controller';
		$facade->renameAction('index', 'foo');
		$facade->addAction('bar');
		$facade->removeAction('show');
		$facade->save(vfsStream::url('root/'));

		$facade = new ControllerFacade(vfsStream::url('root/BarController.php'));
		$this->assertEquals('BarController', $facade->name);
		$this->assertEquals('Foo\Baz\Controller', $facade->namespace);
		$this->assertEquals(array(
			'foo',
			'bar'
		), $facade->actions);
	}

	/**
	 * @test
	 */
	public function simpleChangeController() {
		$this->mockController();
		$facade = new ControllerFacade(vfsStream::url('root/FooController.php'));
		$facade->renameAction('index', 'foo');
		$facade->save(vfsStream::url('root/'));

		$facade = new ControllerFacade(vfsStream::url('root/FooController.php'));
		$this->assertEquals(array(
			'foo', 'show'
		), $facade->actions);
	}

	/**
	 * @test
	 */
	public function removeController() {
		$this->mockController();
		$facade = new ControllerFacade(vfsStream::url('root/FooController.php'));
		$facade->remove();
		$this->assertFalse(file_exists(vfsStream::url('root/FooController.php')));
	}

	/**
	 * @test
	 */
	public function canHandleSubdirectoriesController() {
		$this->mockController();
		$facade = new ControllerFacade(vfsStream::url('root/FooController.php'));
		$facade->name = 'BarController';
		$facade->namespace = 'Foo\Baz\Controller\Backend';
		$facade->renameAction('index', 'foo');
		$facade->addAction('bar');
		$facade->removeAction('show');
		$facade->save(vfsStream::url('root/Backend/'));

		$facade = new ControllerFacade(vfsStream::url('root/Backend/BarController.php'));
		$this->assertEquals('BarController', $facade->name);
		$this->assertEquals('Foo\Baz\Controller\Backend', $facade->namespace);
		$this->assertEquals(array(
			'foo',
			'bar'
		), $facade->actions);
	}
}