<?php

class FrmProCopiesController{

	public static function install() {
        FrmProCopy::install();
    }

    public static function activation_install() {
        // make sure post type exists before creating any views
        FrmProDisplaysController::register_post_types();
        self::install();
    }

	public static function save_copied_display( $id, $values ) {
        global $wpdb, $blog_id;
        $wpdb->delete(FrmProCopy::table_name(), array( 'form_id' => $id, 'type' => 'display', 'blog_id' => $blog_id));

        if ( isset($values['options']['copy']) && $values['options']['copy'] ) {
            FrmProCopy::create( array( 'form_id' => $id, 'type' => 'display'));
        }
    }

	public static function save_copied_form( $id, $values ) {
        global $blog_id, $wpdb;
        if ( isset( $values['options']['copy'] ) && $values['options']['copy'] ) {
            FrmProCopy::create( array( 'form_id' => $id, 'type' => 'form'));
        } else {
            $wpdb->delete(FrmProCopy::table_name(), array( 'type' => 'form', 'form_id' => $id, 'blog_id' => $blog_id));
        }
    }

	public static function destroy_copied_display( $id ) {
        global $blog_id, $wpdb;
        $copies = FrmProCopy::getAll( array( 'blog_id' => $blog_id, 'form_id' => $id, 'type' => 'display'));
		foreach ( $copies as $copy ) {
            FrmProCopy::destroy($copy->id);
            unset($copy);
        }
    }

	public static function destroy_copied_form( $id ) {
        global $blog_id, $wpdb;
        $copies = FrmProCopy::getAll( array( 'blog_id' => $blog_id, 'form_id' => $id, 'type' => 'form'));
		foreach ( $copies as $copy ) {
			FrmProCopy::destroy( $copy->id );
		}
    }

	public static function delete_copy_rows( $blog_id, $drop ) {
        $blog_id = (int) $blog_id;
        if ( ! $drop || ! $blog_id ) {
            return;
        }

		$copies = FrmProCopy::getAll( array( 'blog_id' => $blog_id ) );
		foreach ( $copies as $copy ) {
			FrmProCopy::destroy( $copy->id );
			unset( $copy );
        }
    }
}
