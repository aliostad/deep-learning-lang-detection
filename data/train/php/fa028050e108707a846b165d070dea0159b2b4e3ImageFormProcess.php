<?php
/**
 * ImageFormProcess.php
 *
 * @author  Jiří Šifalda <sifalda.jiri@gmail.com>
 * @package Flame\CMS
 *
 * @date    15.12.12
 */

namespace Flame\CMS\AdminModule\Forms\Images;

class ImageFormProcess extends \Nette\Object
{


	/**
	 * @var \Flame\CMS\Models\Images\ImageFacade $imageFacade
	 */
	private $imageFacade;

	/**
	 * @var \Flame\CMS\Models\ImageCategories\ImageCategoryFacade $imageCategoryFacade
	 */
	private $imageCategoryFacade;

	/**
	 * @var \Flame\Tools\Files\FileManager $fileManager
	 */
	private $fileManager;

	/**
	 * @param \Flame\Tools\Files\FileManager $fileManager
	 */
	public function injectFileManager(\Flame\Tools\Files\FileManager $fileManager)
	{
		$this->fileManager = $fileManager;
	}

	/**
	 * @param \Flame\CMS\Models\ImageCategories\ImageCategoryFacade $imageCategoryFacade
	 */
	public function injectImageCategoryFacade(\Flame\CMS\Models\ImageCategories\ImageCategoryFacade $imageCategoryFacade)
	{
		$this->imageCategoryFacade = $imageCategoryFacade;
	}

	/**
	 * @param \Flame\CMS\Models\Images\ImageFacade $imageFacade
	 */
	public function injectImageFacade(\Flame\CMS\Models\Images\ImageFacade $imageFacade)
	{
		$this->imageFacade = $imageFacade;
	}

	/**
	 * @param ImageForm $form
	 */
	public function sendUpload(ImageForm $form)
	{
		$values = $form->getValues();

		if(count($values->images)){
			foreach($values->images as $image){

				if($image->isOk()) {
					$imageModel = new \Flame\CMS\Models\Images\Image($this->fileManager->saveFile($image));
					$imageModel->setName($values->name)
						->setDescription($values->description)
						->setPublic($values->public);

					if($category = $this->imageCategoryFacade->getOne($values->category)){
						$imageModel->setCategory($category);
					}

					$this->imageFacade->save($imageModel);
				}
			}
		}

		$form->presenter->flashMessage('Images was uploaded.', 'success');

	}

	/**
	 * @param ImageForm $form
	 * @param \Flame\CMS\Models\Images\Image $image
	 */
	public function sendEdit(ImageForm $form, \Flame\CMS\Models\Images\Image $image)
	{
		$values = $form->getValues();

		$image->setDescription($values->description)
			->setName($values->name)
			->setPublic($values->public);

		if($category = $this->imageCategoryFacade->getOne($values->category)){
			$image->setCategory($category);
		}

		$this->imageFacade->save($image);
		$form->presenter->flashMessage('Image was edited', 'success');
	}

}
