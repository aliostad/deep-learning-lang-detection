 <div id="invoice" class="Print_content_areas">
<table id="Test_description" cellpadding="0" cellspacing="0" width="100%">
 	<tr class="report_heading altrow">
		<td class="heading" width="15%"> No</td>
		<td class="heading" width="25%" align="center">Service Name</td>
		<td class="heading" width="20%">Description</td>
		<td class="heading" width="20%"> Price</td>
	 	<td class="heading" width="20%">Created</td>
	</tr>
	<?php 
	 $sdid = 0;
	$slno = 1;
	$TotalPrice = 0;
  	foreach ($serviceServices as $serviceService){
  	    $TotalPrice = $TotalPrice +  $serviceService['ServiceService']['price'];
         if($serviceService['ServiceDevice']['id']  != $sdid){?>
 	     <tr>
          <td align='left'> <?php echo h($serviceService['ServiceDevice']['name']); 
				 $sdid = $serviceService['ServiceDevice']['id']; ?> </td>
        </tr><?php }?>
      <tr class="testlist_report">
		<td><?php echo $slno;?></td>
		<td><?php echo $serviceService['ServiceService']['name'] ; ?></td>
		<td><?php echo $serviceService['ServiceService']['description']; ?></td>
		<td><?php echo $serviceService['ServiceService']['price']; ?></td>
 		<td><?php echo $this->time->niceshort($serviceService['ServiceService']['created']); ?></td>
	</tr>
   <?php $slno ++;?>
  <?php }?>
 	</tr>
 </table>
 </div>