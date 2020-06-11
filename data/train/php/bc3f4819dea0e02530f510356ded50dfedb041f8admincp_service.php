<?php
/**
 *
 */
class admincp_service extends Controller {

	function __construct() {
		parent::__construct();
	}

	function index() {
		Auth::handleAdminLogin();
		$this -> view -> style = array(URL . 'Views/admincp/service/css/service.css');
		$this -> view -> script = array(URL . 'Views/admincp/service/js/service.js');
		$this -> view -> render_admincp('service/index');

	}

	public function loadServiceList() {
		Auth::handleAdminLogin();
		$this -> model -> loadServiceList();
	}

	public function addServiceDetail() {
		Auth::handleAdminLogin();
		$this -> view -> style = array(
			ASSETS . 'plugins/bootstrap-fileinput/bootstrap-fileinput.css',
			URL . 'Views/admincp/service/css/service.css'
		);
		$this -> view -> script = array(
			ASSETS . 'plugins/bootstrap-fileinput/bootstrap-fileinput.js',
			URL . 'Views/admincp/service/js/service.js'
		);
		$this -> view -> render_admincp('service/add');
	}

	public function saveService() {
		Auth::handleAdminLogin();
		if (isset($_POST['service_type_id']) && isset($_POST['service_name'])) {
			$data['service_type_id'] = $_POST['service_type_id'];
			$data['service_name'] = $_POST['service_name'];
			$data['service_description'] = $_POST['service_description'];
			$this -> model -> saveService($data);
		}
	}

	public function editServiceDetail($service_id) {
		Auth::handleAdminLogin();
		$this -> view -> style = array(
			ASSETS . 'plugins/bootstrap-fileinput/bootstrap-fileinput.css',
			URL . 'Views/admincp/service/css/service.css'
		);
		$this -> view -> script = array(
			ASSETS . 'plugins/bootstrap-fileinput/bootstrap-fileinput.js',
			URL . 'Views/admincp/service/js/service.js'
		);
		$this -> view -> service_id = $service_id;
		$this -> view -> render_admincp('service/edit');
	}

	public function loadServiceDetailEdit() {
		Auth::handleAdminLogin();
		if (isset($_POST['service_id'])) {
			$data['service_id'] = $_POST['service_id'];
			$this -> model -> loadServiceDetailEdit($data['service_id']);
		}
	}

	public function loadServiceType() {
		Auth::handleAdminLogin();
		$this -> model -> loadServiceType();
	}

	public function editService() {
		Auth::handleAdminLogin();
		if (isset($_POST['service_id']) && isset($_POST['service_name']) && isset($_POST['service_type_id'])) {
			$data['service_id'] = $_POST['service_id'];
			$data['service_name'] = $_POST['service_name'];
			$data['service_type_id'] = $_POST['service_type_id'];
			$data['service_description'] = $_POST['service_description'];
			$this -> model -> editService($data);
		}
	}

	public function deleteService() {
		Auth::handleAdminLogin();
		if (isset($_POST['service_id'])) {
			$this -> model -> deleteService($_POST['service_id']);
		}
	}

}
?>