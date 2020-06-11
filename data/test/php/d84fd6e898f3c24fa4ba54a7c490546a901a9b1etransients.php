<?php 

// =============================================================================
// FUNCTIONS/GLOBAL/ADMIN/CUSTOMIZER/TRANSIENTS.PHP
// -----------------------------------------------------------------------------
// Sets transients on various Customizer actions.
// =============================================================================

// =============================================================================
// TABLE OF CONTENTS
// -----------------------------------------------------------------------------
//   01. Before Customizer Save
//   02. After Customizer Save
// =============================================================================

// Before Customizer Save
// =============================================================================

function x_customizer_set_transients_before_save() {
  set_transient( 'x_portfolio_slug_before', x_get_option( 'x_custom_portfolio_slug' ), 60 );
}

add_action( 'customize_save', 'x_customizer_set_transients_before_save' );



// After Customizer Save
// =============================================================================

function x_customizer_set_transients_after_save() {
  set_transient( 'x_portfolio_slug_after', x_get_option( 'x_custom_portfolio_slug' ), 60 );
}

add_action( 'customize_save_after', 'x_customizer_set_transients_after_save' );