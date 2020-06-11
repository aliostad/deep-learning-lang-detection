<?php

include ("../connect/connect_to_mysql.php");

include_once ("../class/notifications.class.php");

$note = new notification ();

$id = $_POST['id'];

$func = $_POST['func'];

$note_type = $_POST['note_type'];

if ($func == 'show_initial_notes') {
      if ($note_type == "notification") {
            $show_notifications = $note->show_notes($id);
      } else if ($note_type == "question_note") {
            $show_notifications = $note->show_question_notes($id);
      } else if ($note_type == "friend_request") {
            $show_notifications = $note->show_friend_requests($id);
      } else if ($note_type == "connection") {
            $show_notifications = $note->show_connections($id);
      }
}

if ($func == 'show_more_notes') {
      $note_id = $_POST['note_id'];
      
      if ($note_type == "notification") {
            $show_notifications = $note->show_notes($id, $note_id);
      } else if ($note_type == "question_note") {
            $show_notifications = $note->show_question_notes($id, $note_id);
      } else if ($note_type == "friend_request") {
            $show_notifications = $note->show_friend_requests($id, $note_id);
      } else if ($note_type == "connection") {
            $show_notifications = $note->show_connections($id, $note_id);
      }
}

echo $show_notifications;

?>