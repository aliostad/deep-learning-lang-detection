<?php

namespace KladnoMinule\Control;

/**
 * Article list
 *
 * @author Jan Marek
 */
class ArticleList extends \Neuron\BaseControl
{
	private $showCategory = true;

	private $showAuthor = true;

	private $enablePaginator = true;



	public function render($articles)
	{
		$this->template->articles = $articles;
		$this->template->showCategory = $this->showCategory;
		$this->template->showAuthor = $this->showAuthor;
		$this->template->showPaginator = $this->enablePaginator;
		$this->template->render();
	}



	public function setShowAuthor($showAuthor)
	{
		$this->showAuthor = $showAuthor;
	}



	public function getShowAuthor()
	{
		return $this->showAuthor;
	}



	public function setShowCategory($showCategory)
	{
		$this->showCategory = $showCategory;
	}



	public function getShowCategory()
	{
		return $this->showCategory;
	}



	public function enablePaginator()
	{
		$this->enablePaginator = true;
	}



	public function disablePaginator()
	{
		$this->enablePaginator = false;
	}



	protected function createComponentPaginator($name)
	{
		$paginator = new \Neuron\Control\Paginator($this, $name);
		$paginator->getPaginator()->setItemsPerPage(16);
	}

}
