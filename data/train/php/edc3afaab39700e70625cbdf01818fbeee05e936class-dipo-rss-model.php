<?php

namespace Dicentis\Feed;

use Dicentis\Core;
use Dicentis\Settings\Dipo_Settings_Controller;
use Dicentis\Dipo_Podcast_Post_Type\Dipo_Show_Model;

/**
 *
 * @author Hans-Helge Buerger <mail@hanshelgebuerger.de>
 * @version 0.2.0
 */
class Dipo_RSS_Model {

	private $properties;
	private $show = null;
	private $episode = null;

	public function __construct() {
		$this->properties = Core\Dipo_Property_List::get_instance();
	}

	public function get_feed_template() {
		return $this->properties->get( 'dipo_templates' ) . '/feed-itunes-template.php';
	}

	public function get_show_slug() {
		$slug = '';

		if ( isset( $_GET['podcast_show'] ) ) {
			$slug = esc_attr( $_GET['podcast_show'] );
		} else {
			if ( isset( $_SERVER['REQUEST_URI'] ) ) {
				$request_uri = esc_url( $_SERVER['REQUEST_URI'] );
			} else {
				$request_uri = '';
			}
			$path = explode( '/', $request_uri );

			if ( $path[sizeof( $path ) - 1] !== '' ) {
				$ext = $path[sizeof( $path ) - 1];
			} else {
				$ext = $path[sizeof( $path ) - 2];
			}

			$index_show = array_search( 'show', $path );

			if ( false == $index_show ) {
				echo '';
				return false;
			}

			$slug = $path[$index_show + 1];
		}

		return $slug;
	}

	public function init_show() {
		$show_slug = $this->get_show_slug();
		if ( !isset( $show_slug ) || '' == $show_slug ) {
			return '';
		}

		$show = new Dipo_Show_Model();
		$show->set_slug( $show_slug );
		$show->update();

		$this->set_show( $show );
	}

	public function set_show( $show ) {
		$this->show = $show;
	}

	public function get_show() {
		return $this->show;
	}

	public function get_file_extensions() {
		$show_model = new \Dicentis\Podcast_Post_Type\Dipo_Episode_Model();
		return $show_model->get_file_extensions();
	}

}
