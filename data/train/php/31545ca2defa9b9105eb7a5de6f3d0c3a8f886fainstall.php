<?php    
    
    require_once __DIR__.'/init.php';
    
    header("Content-Type: text/html; charset=utf-8");
    
    if ($repositoryFactory->getCategoryRepository()->install()
        && $repositoryFactory->getMainAnswerRepository()->install()
        && $repositoryFactory->getMainQuestionRepository()->install()
        && $repositoryFactory->getRelAnswerRepository()->install()
        && $repositoryFactory->getSecondAnswerRepository()->install()
        && $repositoryFactory->getSecondQuestionRepository()->install()
        && $repositoryFactory->getParamRepository()->install()
        && $repositoryFactory->getFileRepository()->install()) {   
        echo "Сайт успешно установлен!<br>Удалите файл " . __FILE__;
    } else {
        die("Ошибка инициализации БД!");
    }
        
    
