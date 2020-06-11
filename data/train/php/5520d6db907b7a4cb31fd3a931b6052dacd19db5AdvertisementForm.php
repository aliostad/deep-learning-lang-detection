<?php
namespace IdeaMaker\Admin\Forms;

use IdeaMaker\Facades\AdvertisementFacade;
use IdeaMaker\Facades\CategoryFacade;
use IdeaMaker\Facades\PrintFacade;
use Nette\Application\UI\Form;
use Nette\ComponentModel;
use Nette\Diagnostics\Debugger;

class AdvertisementForm extends BaseForm
{
    /**
     * @var AdvertisementFacade
     */
    protected $advertisementFacade;

    /**
     * @var PrintFacade
     */
    protected $printFacade;

    /**
     * @var CategoryFacade
     */
    protected $categoryFacade;

    public function __construct(ComponentModel\IContainer $parent = NULL, $name = 'advertisementForm', AdvertisementFacade $staticpageFacade, PrintFacade $printFacade, CategoryFacade $categoryFacade)
    {
        parent::__construct($parent, $name);
        $this->advertisementFacade = $staticpageFacade;
        $this->printFacade = $printFacade;
        $this->categoryFacade = $categoryFacade;

        $this->addGroup('Nastavení');

        $this->addSelect('print_id', 'Tiskové médium', $this->printFacade->findAll()->fetchPairs('id', 'name'));
        $this->addSelect('category_id', 'Kategorie', $this->categoryFacade->findAll()->fetchPairs('id', 'name'));

        $this->addGroup('Inzerát');
        $this->addText('title', 'Nadpis')
            ->addRule(Form::FILLED, 'Je nutné zadat nadpis.')
        ;
        $this->addText('slug', 'SEO URL')
            ->addRule(Form::FILLED, 'Je nutné zadat SEO URL.')
        ;

        $this->addTextArea('content', 'Obsah')
            ->addRule(Form::FILLED, 'Je nutné zadat obsah.')
        ;

        $this->addText('published_from', 'Publikovat od')
            ->addRule(Form::FILLED, 'Je nutné zadat datum publikace.')
            ->getControlPrototype()->addClass('datetimepicker')

        ;

        $this->addText('published_to', 'Publikovat do')
            ->getControlPrototype()->addClass('datetimepicker')
        ;

        $this->addCheckbox('is_active', 'Aktivní');

        $this->addHidden('id');
        $this->addSubmit('save', 'Uložit');
        $this->onSuccess[] = callback($this, 'onSuccess');

    }

    protected function prepareForm()
    {

    }

    public function onSuccess(\Nette\Application\UI\Form $form)
    {
        $advertisementValues = $form->getValues();
        if (!$advertisementValues['published_to']) {
            unset($advertisementValues['published_to']);
        }

        try {
            $savedId = $this->advertisementFacade->save($advertisementValues);
            if (@$advertisementValues['id']) {
                $savedId = $advertisementValues['id'];
            }
            $this->presenter->flashMessage('Záznam byl uložen.');
            $this->presenter->redirect('edit?id='.$savedId);
        } catch (\PDOException $e) {
            if ($e->getCode() == 23000 and $e->errorInfo[1] == 1062) {
                $this->presenter->flashMessage('Zadaná URL již existuje.', 'error');
                $this->presenter->redirect('this');
            }

        }

    }



}