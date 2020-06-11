<? include_once("../core/default.php"); ?>
<? 

	$data_customer = new Csql();
	$data_customer->Connect();
	$data_customer->Query("select * from pre_customer");

?>
<? while(!$data_customer->EOF){ ?>
	<a href="../register/be_infocheck.php?pre_customerid=<?= $data_customer->Rs("pre_customerid"); ?>" target="_blank">
    [<?=T_CHECK;?>]</a>
    <?= $data_customer->Rs("pre_customerid"); ?>
	<?= $data_customer->Rs("pcus_usr_username"); ?>
	<? //= $data_customer->Rs("pcus_usr_password"); ?>
	<?= $data_customer->Rs("pcus_name"); ?>
	<?= $data_customer->Rs("pcus_docname"); ?>
	<?= $data_customer->Rs("pcus_address"); ?>
	<?= $data_customer->Rs("pcus_cnt_id"); ?>
	<?= $data_customer->Rs("pcus_prv_id"); ?>
	<?= $data_customer->Rs("pcus_prv_name"); ?>
	<?= $data_customer->Rs("pcus_tel"); ?>
	<?= $data_customer->Rs("pcus_email"); ?>
	<?= $data_customer->Rs("pcus_remark"); ?>
    
    
<br />

<? $data_customer->MoveNext();	} ?>

