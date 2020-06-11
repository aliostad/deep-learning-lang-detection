<?php

namespace Sunnerberg\SimilarSeriesBundle\Entity;

use Doctrine\ORM\EntityRepository;
use Tmdb\Model\Tv;

class TvShowRepository extends EntityRepository
{

    /**
     * @param Tv $tmdbShow
     * @return null|TvShow
     */
    public function getTvShow(Tv $tmdbShow)
    {
        return $this->getByTmdbId($tmdbShow->getId());
    }

    /**
     * @param $tmdbId
     * @return null|TvShow
     */
    public function getByTmdbId($tmdbId)
    {
        return $this->findOneBy(array('tmdbId' => $tmdbId));
    }

    /**
     * @param $tmdbShow Tv
     * @param TvShow $writeTo If provided, existing show who will get the data written to it
     * @return TvShow
     */
    public function createFromTmdbShow(Tv $tmdbShow, TvShow $writeTo = null)
    {
        if ($writeTo === null) {
            $tvShow = new TvShow();
        } else {
            $tvShow = $writeTo;
        }
        $tvShow->setTmdbId($tmdbShow->getId());
        $tvShow->setName($tmdbShow->getName());
        $tvShow->setPopularity($tmdbShow->getPopularity());
        $tvShow->setVoteAverage($tmdbShow->getVoteAverage());
        $tvShow->setVoteCount($tmdbShow->getVoteCount());
        if ($tmdbShow->getExternalIds()) {
            $tvShow->setImdbId($tmdbShow->getExternalIds()->getImdbId());
        }
        $tvShow->setAirDate($tmdbShow->getFirstAirDate());
        $tvShow->setOverview($tmdbShow->getOverview());

        $posterPath = $tmdbShow->getPosterPath();
        $tvShow->setPosterImage(new MediaObject($posterPath));

        $backdropPath = $tmdbShow->getBackdropPath();
        if ($backdropPath) {
            $tvShow->setBackdropImage(new MediaObject($backdropPath));
        }

        return $tvShow;
    }

}
