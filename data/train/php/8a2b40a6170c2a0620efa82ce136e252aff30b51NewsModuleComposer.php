<?php namespace Dunderfelt\Tony\ViewComposers;


use Dunderfelt\Tony\Contracts\ContentRepository;
use Illuminate\Contracts\View\View;

class NewsModuleComposer {

    /**
     * @var ContentRepository
     */
    private $contentRepository;

    public function __construct(ContentRepository $contentRepository)
    {
        $this->contentRepository = $contentRepository;
    }

    public function compose(View $view)
    {
        $newItems = $this->contentRepository->getNews(3);
        $view->with("news", $newItems);
    }
} 