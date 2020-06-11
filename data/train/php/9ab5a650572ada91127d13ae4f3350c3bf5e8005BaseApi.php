<?php
class BaseApi {

    public function __construct() {
    }

	public function checkError($xmldata, $type){
		// check db con
		// server status
		// parse xml error 
		$error = new Error();
		$error->check($xmldata, $type); // exit inside
		$health_api = new HealthApi();
		$health_api->check();
	}

	public function process($input){
		// API type allowed
		
		// Split to ...
		// $type = $input["type"]; // Judge_Api, List_Api, Exam_Api
		// if (class_exists($type))
		// 	$api = new $type();
		// $api->process();

		switch($input['type']) {
			case 'body_measurement_judge':
				$api = new BodyMeasurementJudgeApi();
				print_r($api->process($input['xmldata']));
			break;
			case 'body_measurement_judge':
				$api = new BodyMeasurementJudgeApi();
				print_r($api->process($input['xmldata']));
			break;
			case 'body_measurement_judge':
				$api = new BodyMeasurementJudgeApi();
				print_r($api->process($input['xmldata']));
			break;
			case 'body_measurement_judge':
				$api = new BodyMeasurementJudgeApi();
				print_r($api->process($input['xmldata']));
			break;
			case 'body_measurement_judge':
				$api = new BodyMeasurementJudgeApi();
				print_r($api->process($input['xmldata']));
			break;
			case 'body_measurement_judge':
				$api = new BodyMeasurementJudgeApi();
				print_r($api->process($input['xmldata']));
			break;
			case 'body_measurement_judge':
				$api = new BodyMeasurementJudgeApi();
				print_r($api->process($input['xmldata']));
			break;
			case 'body_measurement_judge':
				$api = new BodyMeasurementJudgeApi();
				print_r($api->process($input['xmldata']));
			break;
			case 'body_measurement_judge':
				$api = new BodyMeasurementJudgeApi();
				print_r($api->process($input['xmldata']));
			break;
			case 'body_measurement_judge':
				$api = new BodyMeasurementJudgeApi();
				print_r($api->process($input['xmldata']));
			break;
			

			default: 
				//error
			break;
		}

	}

}