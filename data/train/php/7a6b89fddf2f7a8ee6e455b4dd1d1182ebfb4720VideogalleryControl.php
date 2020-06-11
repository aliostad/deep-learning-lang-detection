<?php
use \IdeaMaker\Facades\VideogalleryFacade;
class VideogalleryControl extends BaseControl
{
    /**
     * @var IdeaMaker\Facades\VideogalleryFacade
     */
    protected $videogalleryFacade;

    public function __construct(VideogalleryFacade $videogalleryFacade)
    {
        $this->videogalleryFacade = $videogalleryFacade;
    }

    public function render()
    {
        $template = $this->template;
        $template->setFile(__DIR__.'/VideogalleryControl.latte');
        $template->items = $this->videogalleryFacade->findBy(array('is_active'=>1, 'image IS NOT NULL'));
        \Nette\Diagnostics\Debugger::barDump($template->items);

        $template->render();
    }

}