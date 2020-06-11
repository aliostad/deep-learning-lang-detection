<?php
error_reporting(E_ALL);
require './gen/config.php';
require './inc/functions.php';
require './inc/Template.php';

$show_reset = false;
$show_input = isset($_POST['id']) ? $_POST['id'] : '';
$result = '';
$error = '';

do {
  if (empty($show_input)) {
    break;
  }

  require './inc/DatabaseHandler.php';
  require './inc/save_show_data/SaveShowDatabaseController.php';
  require './inc/save_show_data/ImdbShowPageRetriever.php';
  require './inc/save_show_data/HtmlDataRetriever.php';

  // Keeps track whether we need to do a reset (show already persisted -> delete before writing)
  $delete_show_before_write = false;

  try {
    // Extract show ID from user input
    $show_id = ImdbShowPageRetriever::retrieveShowIdFromUrl($show_input);

    // Check if show exists
    $dbh = (new DatabaseHandler($config))->getDbh();
    $db_controller = new SaveShowDatabaseController($dbh);
    if ($db_controller->showExists($show_id)) {
      if (isset($_POST['reset'])) {
        $delete_show_before_write = true;
      } else {
        $show_reset = true;
        throw new Exception('Show already exists! Did not save.<br>Use reset below to copy the data from IMDb again.');
      }
    }

    // Load cast page HTML
    $imdb_page = ImdbShowPageRetriever::loadCastPageForId($show_id);
    // Extract title and check that ID matches
    $show_title = HtmlDataRetriever::getShowTitle($show_id, $imdb_page);
    // Extract info from HTML into array
    $entry = HtmlDataRetriever::extractCastEntries($imdb_page);

    // Delete existing entries of show if so defined
    if ($delete_show_before_write) {
      $db_controller->deleteShow($show_id);
    }

    // Save show & output info
    $db_controller->saveShowInfo($show_title, $show_id, $entry);
    $result = "Saved show info for $show_title ($show_id)"
            . '<br>Actors: ' . count($entry);
  } catch (Exception $e) {
    $error = $e->getMessage();
  }
} while (0);

$tags = [
  'result' => $result,
  'form_error' => $error,
  'form_input' => htmlspecialchars($show_input),
  'show_reset' => $show_reset
];
Template::displayTemplate('inc/save_show_data/save_show_data.html', $tags);
