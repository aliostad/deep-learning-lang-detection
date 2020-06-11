<?php namespace cokelatsoft\storage;

use Illuminate\Support\ServiceProvider;

class StorageServiceProvider extends ServiceProvider 
{
    public function register() 
    {
        
        //Users
        $this->app->bind(
                'cokelatsoft\storage\repository\AbstractRepository',
                'cokelatsoft\storage\repository\user\UserRepository'              
        );
        
        $this->app->bind(
                'cokelatsoft\storage\repository\user\UserRepository',
                'cokelatsoft\storage\repository\user\EloquentUserRepository'
        );
       
       
        /*
        //Roles
        $this->app->bind(
                'cokelatsoft\storage\repository\AbstractRepository',
                'cokelatsoft\storage\repository\roles\RoleRepository'
                
        );
        */
        $this->app->bind(
                'cokelatsoft\storage\repository\role\RoleRepository',
                'cokelatsoft\storage\repository\role\EloquentRoleRepository'
        );

        $this->app->bind(
                'cokelatsoft\storage\repository\role\QuestionRepository',
                'cokelatsoft\storage\repository\role\EloquentQuestionRepository'
        );
        
        
    }
}

