<?php foreach($shows as $show): ?>
	<div class="posts_box">
	<p>
	<h1 class="posts_index"><?=$show['show_date']?>: <span class="post_user"><?=$show['host_dj_name']?> </span>
   <?php if($show['guest_dj_name']):?>with <?=$show['guest_dj_name']?><?php endif;?> on <?=$show['station_id']?></h1>
	   <?php if($show['show_url']): ?>
			<a href='<?=$show['show_url']?>'>click here to listen</a>
	   <?php endif; ?>

	 <!-- Edit the post -->
        <form method = 'POST' action = '/shows/edit/<?=$show['show_id']?>'>
        <input type = 'submit' value = 'Edit show'>
        </form>
	</div>
</article>
<?php endforeach; ?>

