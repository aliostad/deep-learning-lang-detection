<?php

namespace Series\Matcher;

use Series\Show\Mine\ShowCollection as MineShowCollection;
use Series\Show\Mine\ShowInterface as MineShow;
use Series\Show\Upstream\ShowCollection as UpstreamShowCollection;
use Series\Show\Upstream\ShowInterface as UpstreamShow;
use Series\Utils\GuessInfo;
use Series\Show\Status\StatusRegistry;
use Series\Show\Status\StatusInterface;

class Matcher
{
    private $mineShowCollection;
    private $upstreamShowCollection;
    private $showStatus;
    private $guessInfo;

    private $matchedShowCollection;

    public function __construct(
        MineShowCollection $mineShowCollection = null,
        UpstreamShowCollection $upstreamShowCollection = null,
        StatusInterface $showStatus = null,
        GuessInfo $guessInfo = null
    ) {
        $this->mineShowCollection     = $mineShowCollection ?: new MineShowCollection();
        $this->upstreamShowCollection = $upstreamShowCollection ?: new UpstreamShowCollection();
        $this->showStatus             = $showStatus ?: new StatusRegistry();
        $this->guessInfo              = $guessInfo ?: new GuessInfo();

        $this->matchedShowCollection  = new MatchedShowCollection();
    }

    public function getMatchedShowCollection($byPassShowStatus = false)
    {
        foreach ($this->getMineShowCollection() as $mineShow) {
            foreach ($this->getUpstreamShowCollection() as $upstreamShow) {
                if ($this->isDownloadable($mineShow, $upstreamShow)) {
                    $mineShowTmp = clone $mineShow;
                    $mineShowTmp->setVersion($upstreamShow->getVersion());
                    if ($byPassShowStatus || !$this->showStatus->isAlreadyDownloaded($mineShowTmp)) {
                        if (!$this->matchedShowCollection->contains($mineShowTmp)) {
                            $this->matchedShowCollection->add(new MatchedShow($mineShowTmp));
                        }

                        $this->matchedShowCollection->get($mineShowTmp)->addMatchedShow($upstreamShow);
                    }
                }
            }
        }

        return $this->matchedShowCollection;
    }

    public function isDownloadable(MineShow $mineShow, UpstreamShow $upstreamShow)
    {
        if (!$this->guessInfo->isSameShow($mineShow->getTitle(), $upstreamShow->getTitle())) {
            return false;
        }

        return (0 >= version_compare($mineShow->getVersion(), $upstreamShow->getVersion()));
    }

    public function getMineShowCollection()
    {
        return $this->mineShowCollection;
    }

    public function setMineShowCollection($mineShowCollection)
    {
        $this->mineShowCollection = $mineShowCollection;

        return $this;
    }

    public function getUpstreamShowCollection()
    {
        return $this->upstreamShowCollection;
    }

    public function setUpstreamShowCollection($upstreamShowCollection)
    {
        $this->upstreamShowCollection = $upstreamShowCollection;

        return $this;
    }

    public function getShowStatus()
    {
        return $this->showStatus;
    }

    public function setShowStatus(StatusInterface $newShowStatus)
    {
        $this->showStatus = $newShowStatus;
    }

}
