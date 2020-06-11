<?php namespace App\Handlers\Commands;

use App\Commands\SaveProduct;

use App\Repositories\ImageRepository;
use App\Repositories\ProductRepository;
use Illuminate\Queue\InteractsWithQueue;

class SaveProductHandler {

	/**
	 * @var ProductRepository
	 */
	private $productRepository;
	/**
	 * @var ImageRepository
	 */
	private $imageRepository;

	/**
	 * Create the command handler.
	 *
	 * @param ProductRepository $productRepository
	 * @param ImageRepository $imageRepository
	 */
	public function __construct(ProductRepository $productRepository, ImageRepository $imageRepository)
	{
		//
		$this->productRepository = $productRepository;
		$this->imageRepository = $imageRepository;
	}

	/**
	 * Handle the command.
	 *
	 * @param  SaveProduct  $command
	 * @return void
	 */
	public function handle(SaveProduct $command)
	{
		$this->productRepository->save($command->input);

		$modelNumber = $this->productRepository->findLastSavedModelNumber();

		$productId = (int) $this->productRepository->findLastSavedId();

		$imageCount = $this->imageRepository->count() + 1;

		$this->imageRepository->uploadImages($command->input['images'], $modelNumber, $productId, $imageCount);

	}

}
