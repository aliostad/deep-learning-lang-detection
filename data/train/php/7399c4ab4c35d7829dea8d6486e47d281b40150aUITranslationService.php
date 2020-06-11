<?php
namespace Tectonic\Shift\Modules\Localisation\Services;

use Tectonic\Shift\Modules\Localisation\Contracts\LanguageRepositoryInterface;
use Tectonic\Localisation\Contracts\TranslationRepositoryInterface;

class UITranslationService
{
    /**
     * @var LocaleRepositoryInterface
     */
    protected $languageRepository;

    /**
     * @var LocalisationRepositoryInterface
     */
    protected $translationRepository;

    /**
     * @param LocaleRepositoryInterface $languageRepository
     * @param LocalisationRepositoryInterface $translationRepository
     */
    public function __construct(
        LanguageRepositoryInterface $languageRepository,
        TranslationRepositoryInterface $translationRepository
    ) {
        $this->languageRepository = $languageRepository;
        $this->translationRepository = $translationRepository;
    }

    /**
     * Get UI translations
     *
     * @param array $languages
     * @return array
     */
    public function getUITranslations(array $languages = [])
    {
        $languageIds = $this->languageRepository->getLanguageIds($languages);

        return $this->translationRepository->getUITranslations($languageIds);
    }
}
