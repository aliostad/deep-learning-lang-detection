<?php
namespace CASS\Domain\Bundles\Colors\Service;

use CASS\Domain\Bundles\Colors\Entity\Palette;
use CASS\Domain\Bundles\Colors\Repository\ColorsRepository;
use CASS\Domain\Bundles\Colors\Repository\PaletteRepository;

class ColorsService
{
    /** @var ColorsRepository */
    private $colorRepository;

    /** @var PaletteRepository */
    private $paletteRepository;

    public function __construct(ColorsRepository $colorRepository, PaletteRepository $paletteRepository)
    {
        $this->colorRepository = $colorRepository;
        $this->paletteRepository = $paletteRepository;
    }

    public function getColors(): array
    {
        return $this->colorRepository->getColors();
    }

    public function getPalettes(): array
    {
        return $this->paletteRepository->getPalettes();
    }

    public function getRandomPalette(): Palette
    {
        $palettes = $this->paletteRepository->getPalettes();

        return $palettes[array_rand($palettes)];
    }
}