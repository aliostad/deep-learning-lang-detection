<?php
include(dirname(__FILE__)."/settings.php");

$tv_api = ApiWrapper::load($data);

if($_GET['add_show']){
	$api_id = $_GET['add_show'];

	//lookup if already have this show
	$show = Show::loadFromApi($api_id);

	if(!$show || !$show->getId()){
		//this show is new
		$data = $tv_api->getShow($api_id);

		$show = Show::create($data);

		$show_id = $show->getId();
	}
	else{
		//$show->update($data);
		$show_id = $show->getId();
	}

	$session->getUser()->AddShow($show_id);

	//if no episode found then need to generate them first
	$show->syncEpisodes('latest');
	Url::redirect('/');
}


//todo - make this a panel not a table (because of image)
$table_data = array('class' => 'table table-hover table-striped');
$table      = new Table($table_data);

foreach($tv_api->searchShows($_GET['search']) as $show){

	$add_show = new Url();
	$add_show->addParam('add_show', $show->getShowId());
	$add_show->setLabel('<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>');

	$data = array(
		'api_id'   => $show->getShowId(),
		'image'    => "<img src='".$show->getImage()."' />",
		'title'    => $show->getName(),
		'add_show' => $add_show
	);
	$table->addRow($data);
}

echo $table->buildTable();
