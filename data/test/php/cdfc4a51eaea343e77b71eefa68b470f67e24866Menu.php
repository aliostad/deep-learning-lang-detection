<?php
/**
 * Copyright (c) 2014 Pavel Paulík (http://www.pavelpaulik.cz)
 *
 * slider
 *
 * @created 14.9.14
 * @package ${MODULE_NAME}Module
 * @author  Pavel
 */

namespace App\FrontModule\components;


use App\AdminModule\repositories\ArticleRepository;
use App\AdminModule\Repositories\CatalogItemRepository;
use App\AdminModule\Repositories\CatalogRepository;
use Nette\Application\UI\Control;


interface IMenuFactory
{
    /** @return Menu */
    function create();
}


class Menu extends Control {


    /** @var CatalogRepository */
    private $catalogRepository;

    /** @var CatalogItemRepository */
    private $catalogItemRepository;

    /** @var ArticleRepository */
    private $articleRepository;


    public function __construct(
        CatalogRepository $catalogRepository,
        CatalogItemRepository $catalogItemRepository,
        ArticleRepository $articleRepository)
    {
        $this->catalogRepository     = $catalogRepository;
        $this->catalogItemRepository = $catalogItemRepository;
        $this->articleRepository     = $articleRepository;
    }



    public function render()
    {
        $template = $this->template;
        $template->setFile(__DIR__ . '/menu.latte');

        $urls = array();
        $urls[] = array(
            'presenter' => 'Homepage',
            'action' => 'default',
            'id' => null,
            'name' => 'Home',
        );


        $template->slides = $this->articleRepository->findBy(array('section' => 'slider'));
        $template->render();
    }




}
