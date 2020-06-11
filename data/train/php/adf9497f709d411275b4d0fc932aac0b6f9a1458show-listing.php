<?php $show_id = get_the_ID(); ?>
<div class="show">

    <div class="show-date">
        <?php echo get_show_date( $show_id ); ?>
    </div><!-- end .show-date -->

    <div class="show-event">
        <?php echo get_the_event( $show_id ); ?>
    </div><!-- end .show-event -->

    <div class="show-location">
        <?php echo get_the_location( $show_id ); ?> @ <?php echo get_the_venue( $show_id ); ?>
    </div><!-- end .show-location -->

    <div class="show-bands">
        <em>with:</em> <?php echo get_the_bands( $show_id ); ?>
    </div><!-- end .show-bands -->

    <div class="show-lineup">
        <em>played as:</em> <?php echo get_the_lineup( $show_id ); ?>
    </div><!-- end .show-lineup -->

    <div class="show-tour">
        <?php echo get_the_tour( $show_id ); ?>
    </div><!-- end .show-tour -->

    <div class="show-flyer">
		<?php echo get_the_post_thumbnail( get_the_ID(), 'thumbnail' ); ?>
    </div><!-- end .show-flyer -->

    <div class="show-photos">

    </div><!-- end .show-photos -->

</div><!-- end .show -->
