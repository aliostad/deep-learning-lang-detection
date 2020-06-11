<?php
class ServiceController extends FrontController
{
    public function actionIndex($service_id = null)
    {
        $service_types = ServiceType::model()->findAll(array(
           'order'=>'sort_order'
        ));

        $service = $service_id ? $service_id : $service_types[0]->service_type_id;

        $this->checkCompare('ServiceType', 'service_type_id=:service_type_id', array(':service_type_id'=>$service), 'тип услуги');

        $services = Service::model()->findAll(array(
            'condition'=>'service_type_id=:service_type_id',
            'params'=>array(':service_type_id'=>$service),
            'order'=>'sort_order'
        ));

        $this->title('Услуги');
        $this->active($service);

        $this->render('list', array(
            'service_types'=>$service_types,
            'services'=>$services
        ));
    }

    public function actionShow($service_id)
    {
        $this->checkCompare('Service', 'service_id=:service_id', array(':service_id'=>$service_id), 'услуга');
        $service = Service::model()->findByPk($service_id);
        $organization = Organization::model()->findByPk($service->organization_id);

        $this->title($service->title);
        $this->render('item', array(
            'service'=>$service,
            'organization'=>$organization
        ));
    }
}