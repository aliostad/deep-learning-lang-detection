<?php
namespace Course\Service;

use \Doctrine\ORM\EntityManager;
use Course\Service\MPOTTraversalFacade;
use Course\Entity\CourseCategory;
	
class CourseCategoryFacade extends AbstractFacade {
	
	protected $treeFacade;	
	
	/**
	 * Setting tree facade
	 * @param Course\Service\MPOTTraversalFacade $treeFacade
	 */
	public function setTreeFacade(\Course\Service\MPOTTraversalFacade $treeFacade) {
		$this->treeFacade = $treeFacade;
	}
	
 	public function findAll(){
 		return parent::findAll('Course\Entity\CourseCategory');
 	}
 	
 	/**
 	 * This method will use the tree facade to get subtree of root node
 	 */
 	public function getMainTree() {
		$rootNode = $this->treeFacade->getRootNode(CourseCategory::ENTITY_REPOSITORY);
		if ($rootNode) {
			return $this->treeFacade->getTreeHierarchy($rootNode);
		}
 	}
}
