<?php

    namespace Maradik\Hinter\Core;
    
    class Params 
    {
        const KEY_CACHE_ID = 'cache_id';
        
        /**
         * @var ParamRepository $paramRepository 
         */
        static protected $paramRepository;  
        
        /**
         * @param ParamRepository $paramRepository 
         */        
        static public function setRepository(ParamRepository $paramRepository) 
        {
            self::$paramRepository = $paramRepository;
        }  
        
        /**
         * @return ParamRepository $paramRepository 
         */
        static public function getRepository() 
        {
            return self::$paramRepository;
        }      
        
        /**
         * Сохранить параметр. 
         * 
         * @param string $key Ключ
         * @param string $value Значение
         * @param ParamRepository $paramRepository Репозиторий
         * 
         * @return boolean True - в случае успеха.
         */
        static public function put($key, $value, $paramRepository = null)
        {
            $ret = true;
            $paramRepository = isset($paramRepository) ? $paramRepository : self::$paramRepository;
            
            if (!$paramRepository || !($paramRepository instanceof \Maradik\Hinter\Core\ParamRepository) ) {
                throw new \BadMethodCallException('Не передан корректный параметр $paramRepository');
            }
            
            $param = $paramRepository->getByKey($key);
            
            if ($param) {
                $param->value = $value;
            } else {
                $param = new ParamData($key, $value);
            }
            
            if ($ret = $param->validate()) {
                $ret = empty($param->id) ? $paramRepository->insert($param) : $paramRepository->update($param);
            }
            
            return $ret;
        }   
        
        /**
         * Получить параметр.
         * 
         * @param string $key Ключ.
         * @param string $defaultValue Вернет это значение, если данный параметр ранее не сохранялся.
         * @param ParamRepository $paramRepository Репозиторий
         * 
         * @return string Значение параметра с ключом $key
         */
        static public function get($key, $defaultValue = '', $paramRepository = null)
        {
            $paramRepository = isset($paramRepository) ? $paramRepository : self::$paramRepository;
            
            if (!$paramRepository || !($paramRepository instanceof \Maradik\Hinter\Core\ParamRepository) ) {
                throw new \BadMethodCallException('Не передан корректный параметр $paramRepository');
            }  
            
            $param = $paramRepository->getByKey($key);    
            
            return !empty($param) ? $param->value : $defaultValue;                  
        }          
    }
