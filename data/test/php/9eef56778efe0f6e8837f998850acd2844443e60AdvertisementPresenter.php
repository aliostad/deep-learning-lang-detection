<?php
namespace AdminModule;
use AdminModule\Components\Grids\AdvertisementGrid;
use IdeaMaker\Admin\Forms\AdvertisementForm;
use IdeaMaker\Facades\AdvertisementFacade;
use IdeaMaker\Facades\CategoryFacade;
use IdeaMaker\Facades\PrintFacade;
use Nette\Diagnostics\Debugger;
use Nette\InvalidArgumentException;

class AdvertisementPresenter extends BasePresenter
{

    /**
     * @var AdvertisementGrid
     * @inject
     */
    protected $grid;

    /**
     * @var \IdeaMaker\Admin\Forms\AdvertisementForm
     */
    protected $form;

    /**
     * @var AdvertisementFacade
     */
    protected $advertisementFacade;

    /**
     * @var CategoryFacade
     */
    protected $categoryFacade;

    /**
     * @var PrintFacade
     */
    protected $printFacade;

    /**
     * @param AdvertisementGrid $advertisementGrid
     */
    public function injectAdvertisementGrid(AdvertisementGrid $advertisementGrid)
    {
        $this->grid = $advertisementGrid;
    }

    /**
     * @param AdvertisementFacade $advertisementFacade
     */
    public function injectAdvertisementFacade(AdvertisementFacade $advertisementFacade)
    {
        $this->advertisementFacade = $advertisementFacade;
    }

    /**
     * @param PrintFacade $printFacade
     */
    public function injectPrintFacade(PrintFacade $printFacade)
    {
        $this->printFacade = $printFacade;
    }

    /**
     * @param CategoryFacade $categoryFacade
     */
    public function injectCategoryFacade(CategoryFacade $categoryFacade)
    {
        $this->categoryFacade = $categoryFacade;
    }

    // COMPONENTS

    /**
     * @return AdvertisementGrid
     */
    public function createComponentGrid()
    {

        return $this->grid;

    }

    /**
     * @return AdvertisementForm
     */
    public function createComponentAdvertisementForm()
    {
        $this->form = new AdvertisementForm($this, 'advertisementForm', $this->advertisementFacade, $this->printFacade, $this->categoryFacade);

        return $this->form;
    }
    // ACTIONS

	public function renderDefault()
	{

	}

    public function renderEdit($id)
    {
//        if (!($this->presenter->getUser()->isInRole('admin') OR $this->presenter->getUser()->getId() == $id)) { // neni admin ani to neni jeho ucet
//            $this->flashMessage('Nemáte dostatečné oprávnení', 'error');
//            $this->redirect('Dashboard:');
//        }
        $advertisement = $this->advertisementFacade->find($id);
        if ($advertisement) {
            $advertisementData = $advertisement->fetch();
            $form = $this->form ? $this->form : $this->createComponentAdvertisementForm();
            $form->setValues($advertisementData);
            Debugger::barDump($advertisementData);
        }else {
            throw new InvalidArgumentException;
        }
    }

    public function renderNew()
    {

    }

    public function renderDelete($id)
    {
        try {
            $this->advertisementFacade->delete($id);
            $this->flashMessage('Inzerát byl smazána.');
        } catch (\Exception $e) {

        }
        $this->redirect('default');

    }

}
