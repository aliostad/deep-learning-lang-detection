<div data-role="page" id="mobile-page" data-theme="b" data-back-btn-text="Accueil">
	<div data-role="header" data-theme="b">
    	<h1>Mes séries</h1>
    </div>
    
    <div data-role="content">
    	
        <ul data-role="listview" data-theme="c" data-filter="true">
    	<?php foreach($shows as $show) { ?>
			<li>
				<?php 
                echo $html->image('show/' . $show['Show']['menu'] . '_t_serie.jpg', array('width' => 18, 'class' => 'ui-li-icon')); 
                echo $html->link($show['Show']['name'], '/mobileShow/' . $show['Show']['id']); 
                if(!empty($show['Show']['moyenne'])) echo '<span class="ui-li-count">' . $show['Show']['moyenne'] . '</span>'; 
                ?>
            </li>
		<?php } ?>
		</ul>

    </div>
    
</div>