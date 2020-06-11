<?php
namespace Vacancy\UiBundle\Controller;

use Vacancy\UiBundle\Repository\DepartmentRepository;
use Vacancy\UiBundle\Repository\LanguageRepository;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;
use Vacancy\UiBundle\Repository\VacancyRepository;

class VacancyController extends Controller
{
    /** @var VacancyRepository */
    private $vacancyRepository;
    /** @var DepartmentRepository */
    private $departmentRepository;
    /** @var LanguageRepository */
    private $languageRepository;

    /**
     * @param VacancyRepository $vacancyRepository
     * @param DepartmentRepository $departmentRepository
     * @param LanguageRepository $languageRepository
     */
    public function __construct(
        VacancyRepository $vacancyRepository,
        DepartmentRepository $departmentRepository,
        LanguageRepository $languageRepository)
    {
        $this->vacancyRepository = $vacancyRepository;
        $this->departmentRepository = $departmentRepository;
        $this->languageRepository = $languageRepository;
    }

    /**
     * @return Response
     */
    public function browseAction()
    {
        return $this->render('VacancyUiBundle:Vacancy:index.html.twig', array(
            'departments' => $this->departmentRepository->findAll(),
            'languages' => $this->languageRepository->findAll(),
            'vacancies' => $this->vacancyRepository->fetchAll()
        ));
    }
}
