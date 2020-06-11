<?php

class FacadesTest extends TestCase
{
    /**
     * @dataProvider getModelFacades
     */
    public function testModelFacades($facade)
    {
        $facade = '\App\Facades\\' . $facade;
        $model = call_user_func([$facade, 'getModel']);
        $this->assertInstanceOf('\Illuminate\Database\Eloquent\Model', $model);
    }

    public function getModelFacades()
    {
        return [
            ['Drug'],
            ['DrugIndication'],
            ['DrugReview'],
            ['DrugSideEffect'],
            ['User']
        ];
    }

    /**
     * @dataProvider getServiceFacades
     */
    public function testServiceFacades($facade)
    {
        $facade = call_user_func(['\App\Facades\\' . $facade, 'getFacadeRoot']);
        $this->assertInstanceOf('\App\Services\RestAPI', $facade);
    }

    public function getServiceFacades()
    {
        return [
            ['OpenFDA'],
            ['RXClass'],
            ['RXNorm']
        ];
    }
}
