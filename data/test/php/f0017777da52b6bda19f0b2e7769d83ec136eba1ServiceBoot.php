<?php
use service\ArticleService;
use service\CategoryService;
use service\TagService;
use service\ArticleTagMapService;
use service\CommentService;
use service\UserService;
use service\PageService;
use service\MenuService;
use service\AsideService;
use service\LinksService;
use service\FileService;
use service\RsaService;
use service\SEOService;

$di->setShared('ArticleService',function () use($di){
    return new ArticleService($di);
});

$di->setShared('CategoryService',function () use($di){
    return new CategoryService($di);
});

$di->setShared('TagService',function () use($di){
    return new TagService($di);
});

$di->setShared('ArticleTagMapService',function () use($di){
    return new ArticleTagMapService($di);
});

$di->setShared('CommentService',function () use($di){
    return new CommentService($di);
});

$di->setShared('UserService',function () use($di){
    return new UserService($di);
});

$di->setShared('PageService',function () use($di){
    return new PageService($di);
});

$di->setShared('MenuService',function () use($di){
    return new MenuService($di);
});

$di->setShared('AsideService',function () use($di){
    return new AsideService($di);
});

$di->setShared('RsaService',function () use($di){
    return new RsaService($di);
});
    

$di->setShared('LinksService',function () use($di){
    return new LinksService($di);
});

$di->setShared('FileService',function () use($di){
    return new FileService($di);
});

$di->setShared('SEOService',function () use($di){
    return new SEOService($di);
});