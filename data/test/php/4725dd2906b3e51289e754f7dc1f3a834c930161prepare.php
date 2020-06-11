<?

$src = "../__output/";
$path = "";
$dest = ""; 
$verbose = 1;
include('adv_copy.php');

echo ("\nDEV\n");
doCopy(array('jabberoo.lib','jabberoo_d.lib') , '/c++/__source/jabberoo/bin/' , '../__libs/' , false);
doCopy(array('jabberoo.dll','jabberoo_d.dll') , '/c++/__source/jabberoo/bin/' , '../__output/' , false);
doCopy(array('jabberoo.dll') , '/c++/__source/jabberoo/bin/' , '_kjabber/data/dll/' , false);

doCopy(array('sipxtapi.dll') , '/c++/stamina/test/release/' , '_actio/data/dll/' , false);
doCopy(array('sipxtapi.map') , '/c++/__source/sipx/' , 'debug/' , false);

$dest = "__main/";
echo ("\n$dest\n");
$copy = array(/*'konnekt.exe','ui.dll','devil.dll','ilu.dll','ilut.dll','luaplus.dll'*/
  'changelog.txt','readme.txt'
//  ,'history','temp/temp.txt'
  /*,'plugins/update.dll'*/
//  ,'doc/index.html','doc/roadmap.html','doc/szybka*.html','doc/img/logo.gif','doc/img/roadmap.gif','doc/img/step_*.gif'
  );
doCopy($copy , $src , $dest , true);

echo ("\n_crypt musi byæ WGRYWANY OSOBNO!\n");
  
  
$dest = "_expimp/";
//echo ("\n$dest\n");
//$copy = array(/*'plugins/expimp.dll',*/ 'doc/expimp.html');
//doCopy($copy , $src , $dest);



$dest = "_gg NIC DO KOPIOWANIA!/";
echo ("\n$dest\n");
$copy = array(/*'plugins/gg.dll','libgaduw32.dll'*/);
//doCopy($copy , $src , $dest);

$dest = "_klan/";
echo ("\n$dest\n");
$copy = array(/*'plugins/klan.dll',*/'doc/klan.html','doc/img/klan_*.*');
doCopy($copy , $src , $dest);

$dest = "_kstyle/";
echo ("\n$dest\n");
//$copy = array(/*'plugins/kstyle.dll',*/'doc/kstyle*.*'/*,'themes'*/);
//doCopy($copy , $src , $dest);

echo ("\n_ktransfer musi byæ WGRYWANY OSOBNO!\n");

$dest = "_sms/";
echo ("\n$dest bramki WGRYWANE S¥ RÊCZNIE!\n");
$copy = array(/*'plugins/sms.dll',*/'doc/sms_bramki.html');
doCopy($copy , $src , $dest);

$dest = "_sound/";
echo ("\n$dest\n");
//$copy = array(/*'plugins/sound.dll',*/'sounds/default.xml','sounds/*.wav');
//doCopy($copy , $src , $dest);

  




?>
