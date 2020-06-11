<?php namespace Brigham\Podcast\Builders\Providers\SimplePie;

use Brigham\Podcast\Adapters\Providers\SimplePie\EpisodeAdapter;
use Brigham\Podcast\Adapters\ShowAdapterInterface;
use Brigham\Podcast\Builders\ShowBuilderInterface;

class ShowBuilder implements ShowBuilderInterface {

    protected $show_adapter;
    protected $episodes;
    protected $show;

    protected $feed_provider;
    public function __construct(ShowAdapterInterface $show_adapter)
    {
        $this->show_adapter = $show_adapter;
    }

    public function build()
    {
        $this->show = [
            'name'            => $this->show_adapter->getName(),
            'feed_url'        => $this->show_adapter->getFeedUrl(),
            'description'     => $this->show_adapter->getDescription(),
            'image_src'       => $this->show_adapter->getImageSrc(),
            'last_build_date' => $this->show_adapter->getLastBuildDate(),
            'categories'      => $this->show_adapter->getCategories()
        ];

        foreach ($this->show_adapter->getEpisodes() as $episode) {
            $episode_builder = new EpisodeBuilder(new EpisodeAdapter($episode));
            $episode_builder->build();
            $this->episodes[] = $episode_builder->getEpisode();
        }
    }

    public function getCategories()
    {

    }

    public function getShow()
    {
        return $this->show;
    }

    public function getEpisodes()
    {
        return $this->episodes;
    }
}