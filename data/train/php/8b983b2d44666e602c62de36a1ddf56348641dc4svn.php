<?php

namespace pere\fetcher;

class svn implements \pere\fetcher {

    /**
     * @var \pere\struct\repository 
     */
    public $repository;

    /**
     *
     * @var vcsSvnCliCheckout
     */
    protected $svn;

    /**
     *
     *
     * @param \pere\struct\repository $repository the repository config
     */
    public function __construct( \pere\struct\repository $repository ){
        $this->repository = $repository;
        $this->svn = new \vcsSvnCliCheckout( $this->repository->target );
    }

    /**
     * fetch the repository and extract it to the target dir
     *
     */
    public function fetch(){
        $this->svn->initialize( $this->repository->source );
    }


}