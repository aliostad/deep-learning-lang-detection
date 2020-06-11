<?php

namespace Series\Provider\Mine;

use Series\Show\Mine\ShowCollection;

use Symfony\Component\Yaml\Parser as YamlParser;

class Yaml implements ProviderInterface
{
    private $filename;
    private $showCollection;
    private $showClass;

    public function __construct($filename, $showClass = '\\Series\\Show\\Mine\\Show', ShowCollection $showCollection = null)
    {
        $this->filename       = $filename;
        $this->showClass      = $showClass;
        $this->showCollection = $showCollection ?: new ShowCollection();
    }

    public function fetch()
    {
        $parser = new YamlParser();

        if (!file_exists($this->filename)) {
            throw new \Exception(sprintf('Can not find config file: "%s"', $this->filename));
        }

        $yaml = $parser->parse(file_get_contents($this->filename));

        if (!$yaml['shows']) {
            throw new \Exception(sprintf("You should provide shows in \"%s\". Like : \nshows:\n    - { title: foo, season: 01, episode: 01}", $app['show.file']));
        }

        foreach ($yaml['shows'] as $show) {
            if (!isset($show['title'])) {
                throw new \RuntimeException(sprintf('the show, in the file "%s", have not title "%s"', $this->filename, print_r($show, true)));
            }
            $version = sprintf('%d.%d', isset($show['season']) ? $show['season'] : 0, isset($show['episode']) ? $show['episode'] : 0);
            $this->showCollection->addShow(new $this->showClass($show['title'], $version));
        }

        return $this->showCollection;
    }

    public function getShowCollection()
    {
        return $this->showCollection;
    }

    public function setShowCollection(ShowCollection $newShowCollection)
    {
        $this->showCollection = $newShowCollection;

        return $this;
    }

    public function getShowClass()
    {
        return $this->showClass;
    }

    public function setShowClass($newShowClass)
    {
        $this->showClass = $newShowClass;

        return $this;
    }
}
