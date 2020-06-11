<?php
/**
 * Abstract Template class
 *
 * All templates extend this class, initializing core template hooks
 * @since v0.0.1
 */
class JC_Importer_Template {

	public $_name = '';
	public $_field_groups = array();

	public function __construct() {

		// before record gets imported
		if ( method_exists( $this, 'before_template_save' ) ) {
			add_action( 'jci/before_' . $this->get_name() . '_row_save', array( $this, 'before_template_save' ), 10, 2 );
		}

		// before group save
		if ( method_exists( $this, 'before_group_save' ) ) {
			add_filter( 'jci/before_' . $this->get_name() . '_group_save', array( $this, 'before_group_save' ), 10, 2 );
		}

		// after group save
		if ( method_exists( $this, 'after_group_save' ) ) {
			add_filter( 'jci/after_' . $this->get_name() . '_group_save', array( $this, 'after_group_save' ), 10, 2 );
		}

		// after record has been imported
		if ( method_exists( $this, 'after_template_save' ) ) {
			add_action( 'jci/after_' . $this->get_name() . '_row_save', array( $this, 'after_template_save' ), 10, 2 );
		}

	}

	public function get_name() {
		return $this->_name;
	}

	public function get_groups() {
		return apply_filters( 'jci/template/get_groups', $this->_field_groups );
	}
}