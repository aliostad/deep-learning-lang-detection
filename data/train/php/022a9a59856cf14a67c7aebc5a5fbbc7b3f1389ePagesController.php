<?php

use Psyao\Resume\Languages\LanguageRepository;
use Psyao\Resume\Occupations\CompanyRepository;
use Psyao\Resume\Educations\InstituteRepository;
use Psyao\Resume\Skills\SkillRepository;

class PagesController extends BaseController
{
    /**
     * @var CompanyRepository
     */
    protected $companyRepository;
    /**
     * @var InstituteRepository
     */
    protected $instituteRepository;
    /**
     * @var SkillRepository
     */
    protected $skillRepository;
    /**
     * @var LanguageRepository
     */
    protected $languageRepository;

    function __construct(
        CompanyRepository $companyRepository,
        InstituteRepository $instituteRepository,
        SkillRepository $skillRepository,
        LanguageRepository $languageRepository
    )
    {
        $this->companyRepository = $companyRepository;
        $this->instituteRepository = $instituteRepository;
        $this->skillRepository = $skillRepository;
        $this->languageRepository = $languageRepository;
    }

    /**
     * Display the home page.
     * GET /pages
     *
     * @return Response
     */
    public function home()
    {
        $companies = $this->companyRepository->getAll();
        $institutes = $this->instituteRepository->getAll();
        $skills = $this->skillRepository->getAll();
        $languages = $this->languageRepository->getAll();

        return View::make('pages.home', compact('companies', 'institutes', 'skills', 'languages'));
    }

}