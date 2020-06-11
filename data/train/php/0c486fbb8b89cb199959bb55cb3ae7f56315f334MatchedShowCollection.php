<?php

namespace Series\Matcher;

use Series\Show\Mine\ShowInterface as MineShow;

class MatchedShowCollection
{

    private $collection = array();

    public function get(MineShow $mineShow)
    {
        return $this->collection[$this->getHash($mineShow)];
    }

    public function add(MatchedShow $matchedShow)
    {
        $this->collection[$this->getHash($matchedShow->getMineShow())] = $matchedShow;
    }

    public function contains(MineShow $mineShow)
    {
        return array_key_exists($this->getHash($mineShow), $this->collection);
    }

    public function getCollection()
    {
        return $this->collection;
    }

    public function getHash(MineShow $mineShow)
    {
        return $mineShow->__toString();
    }

}
