insert into plugins (id, name, testedUpTo, stableTag, requiresAtLeast, created, modified) values (49, "ACF Merge Group Tabs", "4.1", "1.0", "3.9", now(), now());


insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (434, 49, "admin_footer", "function ()
{
	$screen = get_current_screen();if(($screen->base == 'post')) {
	echo('
			<!-- ACF Merge Tabs -->
			<script>		
	
				var $boxes = jQuery("#postbox-container-2 .postbox .field_type-tab").parent(".inside");
	
				if ( $boxes.length > 1 ) {
	
				    var $firstBox = $boxes.first();
	
				    $boxes.not($firstBox).each(function(){
					    jQuery(this).children().appendTo($firstBox);
					    jQuery(this).parent(".postbox").remove();				    
				    });
					
				}
				
			</script>');
}
}", 10, now(), now());
