<?php

namespace NetgluePrismic;

use Prismic\Api;

trait ApiAwareTrait
{

    /**
     * Prismic Api Instance
     * @var Api|NULL
     */
    protected $prismicApi;

    /**
     * Set the Prismic Api Instance
     * @param  Api  $api
     * @return void
     */
    public function setPrismicApi(Api $api)
    {
        $this->prismicApi = $api;
    }

    /**
     * Return Prismic Api instance
     * @return Api|NULL
     */
    public function getPrismicApi()
    {
        return $this->prismicApi;
    }

}
