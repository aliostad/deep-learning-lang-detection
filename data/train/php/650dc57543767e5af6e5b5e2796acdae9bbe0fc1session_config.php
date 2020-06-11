<?php
function open($save_path, $session_name)
{
  global $sess_save_path;

  $sess_save_path = $save_path;
  return(true);
}

function close()
{
  return(true);
}

function read($id)
{
  global $sess_save_path;

  $sess_file = "$sess_save_path/sess_$id";
  return (string) @file_get_contents($sess_file);
}

function write($id, $sess_data)
{
  global $sess_save_path;

  $sess_file = "$sess_save_path/sess_$id";
  if ($fp = @fopen($sess_file, "w")) {
    $return = fwrite($fp, $sess_data);
    fclose($fp);
    return $return;
  } else {
    return(false);
  }

}

function destroy($id)
{
  global $sess_save_path;

  $sess_file = "$sess_save_path/sess_$id";
  return(@unlink($sess_file));
}

function gc($maxlifetime)
{
  global $sess_save_path;

  foreach (glob("$sess_save_path/sess_*") as $filename) {
    if (filemtime($filename) + $maxlifetime < time()) {
      @unlink($filename);
    }
  }
  return true;
}

session_set_save_handler("open", "close", "read", "write", "destroy", "gc");
session_save_path("/tmp");
session_start();

// proceed to use sessions normally

?>