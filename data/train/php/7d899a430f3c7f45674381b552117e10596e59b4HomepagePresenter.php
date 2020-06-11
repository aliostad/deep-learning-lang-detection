<?php

/**
 * Homepage presenter.
 */
class HomepagePresenter extends BasePresenter
{
	/** @var NewsFacade */
	private $newsFacade;

	/** @var CategoryFacade */
	private $categoryFacade;

	/**
	 * @param NewsFacade
	 */
	public function injectNewsFacade(NewsFacade $newsFacade)
	{
		$this->newsFacade = $newsFacade;
	}

	/**
	 * @param CategoryFacade
	 */
	public function injectCategoryFacade(CategoryFacade $categoryFacade)
	{
		$this->categoryFacade = $categoryFacade;
	}

	public function renderDefault()
	{
		for ($index = 1; $index <= 2; $index++) {
			$category = $this->categoryFacade->create();
			$category->setName('Testovací kategorie #' . $index);
			$this->categoryFacade->save($category);
		}

		$categories = $this->categoryFacade->findAll();

		for ($index = 1; $index <= 10; $index++) {
			$news = $this->newsFacade->create();
			$news->setCategory($categories[rand(0, count($categories) - 1)]);
			$news->setName('Testovací novinka #' . $index);
			$news->setPublishDate(new \DateTime('- 1 day'));
			$news->setContent('Nějaký obsah');
			$this->newsFacade->save($news);
		}

		$newsArray = $this->newsFacade->findPublished();

		$this->template->newsArray = $newsArray;
		$this->template->categories = $categories;

		foreach ($newsArray as $news) {
			$this->newsFacade->remove($news);
		}

		foreach ($categories as $category) {
			$this->categoryFacade->remove($category);
		}
	}
}
