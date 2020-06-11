<?php

namespace Webaccess\WCMSLaravelStorageJSON;

use Illuminate\Support\ServiceProvider;
use Webaccess\WCMSCore\Context;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONAreaRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONArticleCategoryRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONArticleRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONBlockRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONBlockTypeRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONLangRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONMediaFolderRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONMediaFormatRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONMediaRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONMenuItemRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONMenuRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONPageRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONThemeRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONUserRepository;
use Webaccess\WCMSLaravelStorageJSON\Repositories\JSONVersionRepository;

class WCMSLaravelStorageJSONServiceProvider extends ServiceProvider {

    /**
     * Bootstrap the application services.
     *
     * @return void
     */
    public function boot()
    {
    }

    /**
     * Register the application services.
     *
     * @return void
     */
    public function register()
    {
        //Init repositories
        $jsonFolder = storage_path() . '/w-cms/';

        Context::add('block_type_repository', new JSONBlockTypeRepository($jsonFolder));
        Context::add('page_repository', new JSONPageRepository($jsonFolder));
        Context::add('area_repository', new JSONAreaRepository($jsonFolder));
        Context::add('block_repository', new JSONBlockRepository($jsonFolder));
        Context::add('lang_repository', new JSONLangRepository($jsonFolder));
        Context::add('menu_repository', new JSONMenuRepository($jsonFolder));
        Context::add('menu_item_repository', new JSONMenuItemRepository($jsonFolder));
        Context::add('media_repository', new JSONMediaRepository($jsonFolder));
        Context::add('media_format_repository', new JSONMediaFormatRepository($jsonFolder));
        Context::add('media_folder_repository', new JSONMediaFolderRepository($jsonFolder));
        Context::add('article_repository', new JSONArticleRepository($jsonFolder));
        Context::add('user_repository', new JSONUserRepository($jsonFolder));
        Context::add('article_category_repository', new JSONArticleCategoryRepository($jsonFolder));
        Context::add('theme_repository', new JSONThemeRepository($jsonFolder));
        Context::add('version_repository', new JSONVersionRepository($jsonFolder));
    }
}
