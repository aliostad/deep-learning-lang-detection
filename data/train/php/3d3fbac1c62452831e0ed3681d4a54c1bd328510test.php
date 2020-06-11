<?php
	echo "###################################\n";
	var_dump(posix_getgrnam('localcosadmin'));
	var_dump(posix_getgrgid(100));
	var_dump(posix_getgrnam('cos computer local admins'));
	var_dump(posix_getpwnam('cos computer local admins'));
	var_dump(posix_getgrnam('mi164210'));
	var_dump(posix_getpwnam('mi164210'));
	echo "###################################\n";
	$arr1 = [ 'a', 'b', 'c', 'd'];
	$arr2 = [ 'c', 'a', 'e', 'f'];
	var_dump($arr1);
	var_dump(array_diff($arr1,$arr2));
	echo "###################################\n";
	foreach ($arr1 as $item)
		var_dump($item);

	

?>
