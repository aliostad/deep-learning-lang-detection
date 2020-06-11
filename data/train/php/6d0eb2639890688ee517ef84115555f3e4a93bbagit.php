<?php

namespace pere\fetcher;

class git implements \pere\fetcher {

    /**
     * @var \pere\struct\repository
     */
    public $repository;

    /**
     *
     * @var vcsGitCliCheckout
     */
    protected $git;

    /**
     *
     *
     * @param \pere\struct\repository $repository the repository config
     */
    public function __construct( \pere\struct\repository $repository ){
        $this->repository = $repository;
        $this->git = new \vcsGitCliCheckout( $this->repository->target );
    }

    /**
     * fetch the repository and extract it to the target dir
     *
     */
    public function fetch(){
        $this->git->initialize( $this->repository->source );
    }


}