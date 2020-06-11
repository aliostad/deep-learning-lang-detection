<?php

namespace App\Services;

use App\Repositories\PostRepository;

class PostService
{


    /**
     * @var PostRepository
     */
    private $postRepository;

    public function __construct(PostRepository $postRepository)
    {

        $this->postRepository = $postRepository;
    }


    public function create($data)
    {
        $post = $this->postRepository->create($data);

        // Envia um email
        // notifica o usuario criador do post
        // cria um trackback
        // cria um comentario exemplo

        return $post;

    }

}