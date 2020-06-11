<?php
declare(strict_types=1);

require_once '../vendor/autoload.php';

use Bacon\Config\Config;
use Bacon\Entity\Language;
use Bacon\Entity\Location;
use Bacon\Repository\Neo4jLanguageRepository;
use Bacon\Repository\Neo4jUserRepository;
use Bacon\Repository\Neo4jLocationRepository;
use Bacon\Entity\User;
use Bacon\Repository\Neo4jRepositoryRepository;
use Bacon\Entity\Repository;
use GraphAware\Neo4j\OGM\EntityManager;

$manager = EntityManager::create(Config::get()['neo4jHost']);

$userRepository = new Neo4jUserRepository($manager);
$repositoryRepository = new Neo4jRepositoryRepository($manager);
$locationRepository = new Neo4jLocationRepository($manager);

$user = $userRepository->findOneBy('username', 'aiolos');
var_dump($user);

$repo = $repositoryRepository->findOneBy('repositoryId', 17855566);
var_dump($repo);

die;


$repository1 = new Repository();
$repository1->setName('Repository 1');

$repository2 = new Repository();
$repository2->setName('Repository 2');

$user = new User();
$user->setName('User 1');
$user->setUsername('User name');
$user->setAvatar('Avatar');

$user->contributeToRepository($repository1);
$user->watchRepository($repository1);
$user->starRepository($repository1);

$user->watchRepository($repository2);

$location1 = new Location();
$location1->setLocation('WeCamp');
$locationRepository->persist($location1);

$user->setLocation($location1);

$userRepository->persist($user);
$repositoryRepository->persist($repository1);

$languageRepository = new Neo4jLanguageRepository($manager);

$language1 = new Language();
$language1->setLanguageName('PHP');

$repository1->useLanguage($language1);
$languageRepository->persist($language1);
$repositoryRepository->persist($repository1);

$languageRepository->flush();
$userRepository->flush();
$repositoryRepository->flush();




echo 'done';
