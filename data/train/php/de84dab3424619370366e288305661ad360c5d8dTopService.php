<?php

namespace App\Services;
use App\Repositories\CategoriesRepository;
use App\Repositories\CreatorsRepository;
use App\Repositories\ExperiencesRepository;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Config;

/**
 * Created by PhpStorm.
 * User: eguchi
 * Date: 2016/12/29
 * Time: 19:39
 */
class TopService extends BaseService
{

  private $categoryRepository;
  private $experiencesRepository;
  private $creatorRepository;

  public function __construct(CategoriesRepository $categoryRepository, ExperiencesRepository $experiencesRepository, CreatorsRepository $creatorRepository)
  {
    $this->categoryRepository = $categoryRepository;
    $this->experiencesRepository = $experiencesRepository;
    $this->creatorRepository = $creatorRepository;
  }

  public function getData(Request $request)
  {
    $data = $this->init($request);
    $data = array_merge($data, ["title" => Config::get("const.seo.title.top")]);
    $data["categories"] = $this->categoryRepository->findAll();
    $data["pr-experience"] = $this->experiencesRepository->findPrExperience();
    $data["nominator"] = $this->creatorRepository->findNominator();
    $data["nominator"]["profile-img"] = $this->getS3ProfileImage($data["nominator"]->user_id);
    return $data;
  }
}