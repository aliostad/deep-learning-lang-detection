<html>
<head><title>Array of Key/Value Pairs</title></head>
<body bgcolor="lavender">
<h3>An Array Indexed by String</h3>
<b>
<?php

  $show=array( 'Title'=>'Aga-Boom', 
               'Author'=> 'Dmitri Bogatirev', 
               'Genre'=> 'Physical comedy',
  );
  echo "\$show is $show.<br>\n";

?>

$show['Title'] is <?=$show['Title']?>.<br>
$show['Author'] is <?=$show['Author']?>.<br>
$show['Genre'] is <?=$show['Genre']?>.<br>
<br /><em>Let's add another element to the array.</em><br />
$show['Theater']='Alcazar';<br />

<?php

  $show['Theatre'] = "Alcazar";
  echo $show['Theater']. "<br>\n";
?>
</b>
</body>
</html>
