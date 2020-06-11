<div class="col-md-6">
	<h1>Customers <?php  echo $customer['Customer']['first_name'].' '.$customer['Customer']['last_name'].' ('.$customer['Customer']['id'].')'; ?></h1>

	<p><strong>Address:</strong><?php echo $customer['Customer']['email']; ?></p>
	<p><strong>Address:</strong><?php echo $customer['Customer']['address']; ?></p>

	<?php echo ($customer['Customer']['citi_id']!=0) ? '<p><strong>City:</strong>'.$customer['Customer']['citi_id'].'</p>' : ''; ?>
	<p><strong>Phone: </strong><?php echo $customer['Customer']['phone']; ?></p>
	<p><strong>Birth: </strong><?php echo $customer['Customer']['birth']; ?></p>
	<p><strong>Notes: </strong><?php echo $customer['Customer']['notes']; ?></p>
	<h3><strong>Car Desired</strong></h3>
	<p><strong>Make: </strong><?php echo $customer['Customer']['cardesiredmake']; ?>
	<br><strong>Model: </strong><?php echo $customer['Customer']['cardesiredmodel']; ?>
	<br><strong>Year: </strong><?php echo $customer['Customer']['cardesiredyear']; ?></p>
	<p><strong>Customer created: </strong><?php echo $this->Time->format('d-m-Y | h:i A' , $customer['Customer']['created']); ?></p>
	<p><strong>Last modification: </strong><?php echo $this->Time->format('d-m-Y | h:i A' , $customer['Customer']['modified']); ?></p>
	
	<button type="button" class="btn btn-info btn-xs">
		<?php echo $this->Html->link('Delete',array('controller'=>'customers','action'=>'delete', $customer['Customer']['id'])); ?>
	</button>
				
</div>