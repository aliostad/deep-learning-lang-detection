<?php

$show_theatre_id=$_POST['theatre_id'];
$show_movie_id=$_POST['movie_id'];
$show_date_id=$_POST['date_id'];
$show=$_POST['show'];

$insert=0;
for($i=1;$i<=1000;$i++)
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
//$query="select '".$show."' from show where (show_theatre_id = '".$show_theatre_id."' 
//and show_movie_id = '".$show_movie_id."' and show_date_id = '".$show_date_id."'
//)";
$query = "select show_noon,show_matinee,show_firstshow,show_secondshow FROM `show` WHERE show_theatre_id='$show_theatre_id'
and show_movie_id='$show_movie_id' and show_date_id='$show_date_id'
";
$result = mysql_query($query,$link)or die("wrong query");
if($result)
{       while($row = mysql_fetch_array($result,MYSQLI_ASSOC))
		{
		if($show=="show_noon")
		{
		echo "show is noon";
		$booked=$row['show_noon'].',';}
		if($show=="show_matinee")
		{
		$booked=$row['show_matinee'].',';}
		if($show=="show_firstshow")
		{
		$booked=$row['show_firstshow'].',';}
		if($show=="show_secondshow")
		{
		$booked=$row['show_secondshow'].',';}
		}
}
$booked;
echo $booked;
$insert=$booked.$insert;
echo $insert;
/*
$query1="update show set '".$show."'='$insert' where 
(show_theatre_id = '".$show_theatre_id."' 
and show_movie_id = '".$show_movie_id."' and show_date_id = '".$show_date_id."'
)";
$query1 = "update show set show_noon='$insert' where show_date_id='$show_date_id'"; 
*/
//-------------------------------------------------------------------------
$query1 = "UPDATE  `show` SET  `show_noon` =  '$insert' WHERE 
 `show_date_id` ='$show_date_id' and
 `show_movie_id` = '$show_movie_id' and
 `show_theatre_id` = '$show_theatre_id'  
 ";
//-------------------------------------------------------------------------
if($_POST['show']=="show_matinee")
{
$query1 = "UPDATE  `show` SET  `show_matinee` =  '$insert' WHERE 
 `show_date_id` ='$show_date_id' and
 `show_movie_id` = '$show_movie_id' and
 `show_theatre_id` = '$show_theatre_id'  
 ";
 }
//-------------------------------------------------------------------------
if($_POST['show']=="show_firstshow")
{
$query1 = "UPDATE  `show` SET  `show_firstshow` =  '$insert' WHERE 
 `show_date_id` ='$show_date_id' and
 `show_movie_id` = '$show_movie_id' and
 `show_theatre_id` = '$show_theatre_id'  
 ";
 }
//-------------------------------------------------------------------------
if($_POST['show']=="show_secondshow")
{
$query1 = "UPDATE  `show` SET  `show_secondshow` =  '$insert' WHERE 
 `show_date_id` ='$show_date_id' and
 `show_movie_id` = '$show_movie_id' and
 `show_theatre_id` = '$show_theatre_id'  
 ";
 }
//-------------------------------------------------------------------------
echo $query1;
$result1=  mysql_query($query1,$link);
if($result1)
{echo "inserted the new seats";}
mysql_close($link);
?>