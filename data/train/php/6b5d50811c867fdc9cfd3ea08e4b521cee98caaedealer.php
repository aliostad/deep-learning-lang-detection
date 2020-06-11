<div class='content'>
	<? Breadcrumb::showCrumbs(); ?>
	<? View::show('/main/elements/dealers/profile_header'); ?>	
	<? View::show('/main/elements/dealers/profile'); ?>	
	<? View::show('/main/elements/dealers/client_ratings'); ?>
	<? View::show('/main/elements/dealers/pricelist'); ?>
	<? View::show('/main/elements/dealers/payments'); ?>	
	<? View::show('/main/elements/dealers/delivery'); ?>
	<? if ($manager->is_mail_forwarding) : ?>
	<? View::show('/main/elements/dealers/mail_forwarding'); ?>
	<? endif; ?>
</div>