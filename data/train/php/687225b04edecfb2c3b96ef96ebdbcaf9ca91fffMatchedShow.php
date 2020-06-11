<?php

namespace Series\Matcher;

use Series\Show\Mine\ShowInterface as MineShow;
use Series\Show\Upstream\ShowInterface as UpstreamShow;

class MatchedShow
{

    private $mineShow;
    private $matched; // Upstream

    public function __construct(MineShow $mineShow)
    {
        $this->mineShow = $mineShow;
        $this->matched  = array();
    }

    public function addMatchedShow(UpstreamShow $upstreamShow)
    {
        $this->matched[] = $upstreamShow;
    }

    public function getMatched()
    {
        return $this->matched;
    }

    public function getMineShow()
    {
        return $this->mineShow;
    }

    public function __toString()
    {
        return $this->mineShow->__toString();
    }
}
