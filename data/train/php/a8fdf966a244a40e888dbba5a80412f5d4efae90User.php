<?php
namespace backend\dsl\invoice;


use backend\repositories\UserRepository;

class User {
    /** @var  UserRepository */
    private $_repository;

    /**
     * @return mixed
     */
    public function getRepository()
    {
        if($this->_repository)
        {
            $this->_repository = 1;
        }
        return $this->_repository;
    }

    /**
     * @param mixed $repository
     */
    public function setRepository(UserRepository $repository)
    {
        $this->_repository = $repository;
    }

    public function save()
    {
        return $this->_repository->save();
    }

    public function login($string, $string1)
    {
        $condition = ['username'=>$string,'password'=>$string1];
        $r = $this->_repository->findOne($condition);
        try{
            if($r instanceof UserRepository)
            {
                return $this->generateToken($r);
            }
        }catch (\Exception $e)
        {
            return null;
        }
        return null;
    }

    private function generateToken(UserRepository $r)
    {
        $token = bin2hex(openssl_random_pseudo_bytes(16));
        if($r->addToken($token))
        {
            return $token;
        }
        throw new \Exception("błąd w generowaniu tokena");
    }

}