<!--edit shows-->
	<form method="post">
		<?php
			$show_name = get_post("show_name");
			if (manager() && !$show_name){
				//managers can add shows
				echo('<label>Show Name:</label><input type="text" name = "show_name" value = "" required />');
			}else{
				echo('<input type="text" name = "show_name" value = "'.$show_name.'" class = "hide" required />');
				echo("<h2>$show_name</h2>");
			}
		?>
		<br />
	    	<label>Show description:</label><textarea name="show_desc"><?php echo(get_post("show_desc")); ?></textarea><br>
	    	<label>Show website:</label>https://<input type="text" name="show_website" value = "<?php echo(get_post("show_website")); ?>" /><br>
	    	<input type="submit" name="update_show" value="Save changes" /> 
	</form>
