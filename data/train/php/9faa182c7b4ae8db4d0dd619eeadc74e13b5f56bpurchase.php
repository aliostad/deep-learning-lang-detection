<?php if( get_field("print_copy_link") || get_field("digital_copy_link") ) : ?>

    <p class="btn--more  btn--small">
        <?php if( get_field("print_copy_link") ) : ?>
            <a href="<?php esc_url( the_field('print_copy_link') ); ?>">Print Copy &middot; </a>
        <?php endif; ?>
        <?php if( get_field("digital_copy_link") ) : ?>
            <a href="<?php esc_url( the_field('digital_copy_link') ); ?>">Digital Copy</a>
        <?php endif; ?>
    </p><!-- .btn--more -->
    
<?php endif; ?>