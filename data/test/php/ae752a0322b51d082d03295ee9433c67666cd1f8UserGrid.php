<?php
/**
 * @author Martin Kovařčík.
 */

namespace Admin\User;

use Admin\BaseGrid;
use Model\RoleFacade;
use Model\SectionFacade;
use Model\UserFacade;
use Model\UserFilter;
use Nette\Utils\Html;
use Nette\Utils\Strings;


class UserGrid extends BaseGrid
{

	/** @var \Model\UserFacade */
	private $userFacade;

	/** @var \Model\UserFilter */
	private $userFilter;

	/** @var \Model\SectionFacade */
	private $sectionFacade;

	/** @var \Model\RoleFacade */
	private $roleFacade;

	/**
	 * @param \Model\UserFacade $userFacade
	 * @param \Model\UserFilter $userFilter
	 * @param \Model\SectionFacade $sectionFacade
	 * @param \Model\RoleFacade $roleFacade
	 * @internal param \Model\SectionFacade $sectionFacade
	 */
	function __construct(UserFacade $userFacade, UserFilter $userFilter, SectionFacade $sectionFacade,RoleFacade $roleFacade)
	{
		parent::__construct();

		$this->userFacade = $userFacade;
		$this->userFilter = $userFilter;
		$this->sectionFacade = $sectionFacade;
		$this->roleFacade = $roleFacade;
	}

	protected function createGrid()
	{
		$grid = $this->createPreparedGrid();
		$grid->setModel($this->getModel());

		$grid->addColumnNumber('id', 'ID')
			->setSortable()
			->setFilterNumber();

		$grid->addColumnText('username', 'Přihlašovací jméno')
			->setSortable()
			->setDefaultSort('asc')
			->setFilterText();

		$grid->addColumnText('name', 'Jméno')
			->setSortable()
			->setFilterText();

		$grid->addColumnText('surname', 'Příjmení')
			->setSortable()
			->setFilterText();

		$grid->addColumnText('email', 'Email')
			->setCustomRender(function($row){
				if(Strings::length($row->email)<=0){
					return '';
				}

				return Html::el('a')->setText($row->email)->href('mailto:'.$row->email);
			})
			->setSortable()
			->setFilterText()
			->setColumn('user.email');

		$section = $grid->addColumnText('section', 'Sekce');
		$this->helpers->setupAsMultirecord($section, function ($row) {
			$selection = $this->sectionFacade->all();
			$this->userFilter->filterId($selection, $row->id, ':user_has_section');
			$selection->select("section.id,section.name");

			return $selection->fetchPairs('id', 'name');
		});

		$role = $grid->addColumnText('role', 'Role');
		$this->helpers->setupAsMultirecord($role, function ($row) {
			$selection = $this->roleFacade->all();
			$this->userFilter->filterId($selection, $row->id, ':user_has_role');
			$selection->select("role.code,role.name");

			return $selection->fetchPairs('code', 'name');
		});

		$this->helpers->addEditAction($grid);
		$this->helpers->addDeleteEvent($grid, $this->deleteRow, function ($row) {
			return $row->surname . ' ' . $row->name;
		});

		return $grid;
	}

	/**
	 * @return \Nette\Database\Table\Selection
	 */
	private function getModel()
	{
		return $this->userFacade->all();
	}

	/**
	 * @param int $id
	 */
	public function delete($id)
	{
		$this->userFacade->delete($id);
	}

}

interface IUserGridFactory
{
	/** @return \Admin\User\UserGrid */
	public function create();
}
