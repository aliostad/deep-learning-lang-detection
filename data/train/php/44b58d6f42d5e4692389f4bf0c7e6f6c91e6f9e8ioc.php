<?php

/*
|--------------------------------------------------------------------------
| User binding interfaces
|--------------------------------------------------------------------------
*/
App::bind('IUserRepository', 'UserRepository');
App::bind('IUserService', 'UserService');

//Repositories
App::bind('ITaskRepository', 'TaskRepository');
App::bind('ITaskTypeRepository', 'TaskTypeRepository');
App::bind('IPayerGroupRepository', 'PayerGroupRepository');
App::bind('ILanguageRepository', 'LanguageRepository');