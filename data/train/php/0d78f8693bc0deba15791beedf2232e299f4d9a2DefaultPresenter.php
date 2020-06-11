<?php

namespace FrontModule;

/**
 * Homepage presenter.
 */
class DefaultPresenter extends BasePresenter
{
  private $eshopRepository;
  private $newsRepository;      

	public function startup()
	{          
    parent::startup();
            
    $this->eshopRepository = $this->context->eshopRepository;
    $this->newsRepository = $this->context->newsRepository;
                                                        
	}
    
	public function renderDefault()
	{          
    $this->template->topprodukty = $this->eshopRepository->getTopProducts();
    $this->template->news = $this->newsRepository->getLast(3);                      		
	}
}