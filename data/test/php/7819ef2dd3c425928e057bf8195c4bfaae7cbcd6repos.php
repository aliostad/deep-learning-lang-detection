<?php

$REPOS = array(
	array(
		'name' => 'packageRepository',
		'class' => 'IvyStreet\\Repository\\impl\\PackageRepository',
		'entityManagerName' => 'entityManager'
	),
	array(
		'name' => 'lotRepository',
		'class' => 'IvyStreet\\Repository\\impl\\LotRepository',
		'entityManagerName' => 'entityManager'
	),
	array(
		'name' => 'stageRepository',
		'class' => 'IvyStreet\\Repository\\impl\\StageRepository',
		'entityManagerName' => 'entityManager'
	),
	array(
		'name' => 'builderRepository',
		'class' => 'IvyStreet\\Repository\\impl\\BuilderRepository',
		'entityManagerName' => 'entityManager'
	),
	array(
		'name' => 'newsRepository',
		'class' => 'IvyStreet\\Repository\\impl\\NewsRepository',
		'entityManagerName' => 'entityManager'
	)
);