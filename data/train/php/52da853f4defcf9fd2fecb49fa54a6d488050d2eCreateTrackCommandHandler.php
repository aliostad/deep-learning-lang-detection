<?php

namespace Atrapalo\Application\Model\Track\CreateTrack;

use Atrapalo\Application\Model\Command\Command;
use Atrapalo\Application\Model\Command\CommandHandler;
use Atrapalo\Application\Model\Track\CreateTrack\DataTransformer\CreateTrackCommandResultDataTransformer;
use Atrapalo\Domain\Model\Album\Repository\AlbumRepository;
use Atrapalo\Domain\Model\Genre\Repository\GenreRepository;
use Atrapalo\Domain\Model\MediaType\Repository\MediaTypeRepository;
use Atrapalo\Domain\Model\PlayList\Repository\PlayListRepository;
use Atrapalo\Domain\Model\Track\Entity\Track;
use Atrapalo\Domain\Model\Track\Repository\TrackRepository;

/**
 * Class CreateTrackCommandHandler
 */
class CreateTrackCommandHandler implements CommandHandler
{
    /** @var CreateTrackCommandResultDataTransformer */
    private $dataTransformer;

    /** @var AlbumRepository */
    private $albumRepository;

    /** @var GenreRepository */
    private $genreRepository;

    /** @var MediaTypeRepository */
    private $mediaTypeRepository;

    /** @var PlayListRepository */
    private $playListRepository;

    /** @var TrackRepository */
    private $trackRepository;

    public function __construct(
        CreateTrackCommandResultDataTransformer $dataTransformer,
        AlbumRepository $albumRepository,
        GenreRepository $genreRepository,
        MediaTypeRepository $mediTypeRepository,
        PlayListRepository $playListRepository,
        TrackRepository $trackRepository
    ) {
        $this->dataTransformer = $dataTransformer;
        $this->albumRepository = $albumRepository;
        $this->genreRepository = $genreRepository;
        $this->mediaTypeRepository = $mediTypeRepository;
        $this->playListRepository = $playListRepository;
        $this->trackRepository = $trackRepository;
    }

    /**
     * @param Command|CreateTrackCommand $command
     *
     * @return mixed
     */
    public function handle(Command $command)
    {
        $album = $this->albumRepository->find($command->albumId());
        $genre = $this->genreRepository->find($command->genreId());
        $mediaType = $this->mediaTypeRepository->find($command->mediaTypeId());
        $playList = $this->playListRepository->find(($command->playListId()));

        $track = Track::instance($command->name(), $album)
            ->setComposer($command->composer())
            ->setBytes($command->bytes())
            ->setMilliseconds($command->milliseconds())
            ->setGenre($genre)
            ->setMediaType($mediaType)
            ->setUnitPrice($command->unitPrice());

        $this->trackRepository->save($track);
        $playList->addTrack($track);
        $this->playListRepository->save($playList);

        return $this->dataTransformer->transform(
            CreateTrackCommandResult::instance($track)
        );
    }
}
