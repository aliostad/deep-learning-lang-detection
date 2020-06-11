<?php
include '../settings.php';

$show = $_GET['show'];
$last_show = $_GET['last_show'];

$sql = "UPDATE status_info
				SET status_value=".$show."
				WHERE status_key='active_show';
				UPDATE status_info
				SET status_value=".$last_show."
				WHERE status_key='last_show'";

if ($result = mysqli_multi_query($con, $sql)) {
	$response = array(
		'status' => 'success',
		'show' => $show,
		'last_show' => $last_show
	);
} else {
	$response = array(
		'status' => 'error',
		'error' => mysqli_error($con)
	);
}
echo json_encode($response);

?>
