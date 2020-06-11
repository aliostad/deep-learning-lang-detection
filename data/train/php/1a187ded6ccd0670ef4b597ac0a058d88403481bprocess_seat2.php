<?php

$show_theatre_id="1000"; //$_POST['theatre_id'];
$show_movie_id="1000";   //$_POST['movie_id'];
$show_date_id="1000";    //$_POST['date_id'];
$show="show_noon";       //$_POST['show'];

$insert=0;
for($i=1;$i<=120;$i++)
{
if(!empty($_POST['seat'.$i]))
{
$insert=$insert.','.$i;
}
}
echo $insert;
//will be moved after the payment completed page later
$link=mysql_connect("localhost","root","root")or die("can not connect");
mysql_select_db("booking_system",$link) or die("can not select database");

//$query="select theatre_seat_booked from theatre where theatre_id = '".$theatre_id."'";
$query="select '".$show."' from show where (show_theatre_id = '".$show_theatre_id."' 
and show_movie_id = '".$show_movie_id."' and show_date_id = '".$show_date_id."'
)";
$result = mysql_query($query,$link)or die("wrong query");
if($result)
{       while($row = mysql_fetch_array($result,MYSQLI_ASSOC))
		{
		if($show=="show_noon")
		{$booked=$row['show_noon'].',';}
		if($show=="show_matinee")
		{$booked=$row['show_matinee'].',';}
		if($show=="show_firstshow")
		{$booked=$row['show_firstshow'].',';}
		if($show=="show_secondshow")
		{$booked=$row['show_secondshow'].',';}
		}
}
echo $booked;
$insert=$booked.$insert;
echo $insert;
$query1="update show set '".$show."'='$insert' where 
(show_theatre_id = '".$show_theatre_id."' 
and show_movie_id = '".$show_movie_id."' and show_date_id = '".$show_date_id."'
)";
echo $query1;
$result1=  mysql_query($query1,$link);
mysql_close($link);
?>