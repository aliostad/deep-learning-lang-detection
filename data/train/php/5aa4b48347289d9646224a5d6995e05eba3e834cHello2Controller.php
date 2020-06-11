<?php
namespace Acme\HelloBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use \Symfony\Bundle\TwigBundle\TwigEngine;

/**
 * @Route(service = "controller.hello2")
 */
class Hello2Controller
{
	private $twigEngine;
	private $fetchProductsFacade;

	public function __construct(TwigEngine $twigEngine, \Acme\HelloBundle\Facade\FetchProductsFacade $fetchProductsFacade) {
		$this->twigEngine = $twigEngine;
		$this->fetchProductsFacade = $fetchProductsFacade;
	}

	/**
	 * @Route("/hello2/{name}")
	 */
	public function indexAction($name)
	{
		$product = $this->fetchProductsFacade->getProduct();

		return $this->twigEngine->renderResponse(
			'AcmeHelloBundle:Hello2:index.html.twig',
			array(
				'name' => $name,
				'myVariable' => 'Jirka, name: ' . $product->getName()
			)
		);
	}

}