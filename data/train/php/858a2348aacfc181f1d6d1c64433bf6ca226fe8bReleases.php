<?php

namespace App\Services\GitHub;

use App\Models\Repository\Repository;

class Releases extends Interactor
{
    /**
     * Pulls a release down for local use.
     *
     * @param \App\Models\Repository\Repository $repository
     * @param string                            $destination
     * @param string                            $link
     * @param string                            $tag
     *
     * @return bool
     */
    public function pull(Repository $repository, $destination, $link = null, $tag = null)
    {
        $link = ($link === null ? $this->link($repository, $tag) : $link);

        if ($link === null) {
            return false;
        }

        return $this->download($repository->token, $link, $destination);
    }

    /**
     * Gets a download link to a repository's specific tag.
     *
     * @param \App\Models\Repository\Repository $repository
     * @param string                            $tag
     *
     * @return string|null
     */
    public function link(Repository $repository, $tag)
    {
        $tag = strlen($tag) === 0 ? env('GIT_BRANCH') : $tag;

        return 'repos/'.$repository->getRouteKey().'/zipball/'.$tag;
    }
}
