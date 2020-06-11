<?php

class ServiceController extends BaseController {

    public function index() {
        return Service::all();
    }

    public function show($id) {
        return Service::find($id);
    }

    public function store() {
        if (Input::has('ticket', 'employee')) {
            $service = new Service();
            $service->ticket_id = Input::get('ticket');
            $service->employee = Input::get('employee');
            $service->save();
            return $service;
        } else if (Input::has('code', 'place', 'employee')) {
            $ticket = Ticket::where('code', Input::get('code'))
                ->where('place_id', Input::get('place'))
                ->orderBy('id', 'desc')
                ->first();
            $service = new Service();
            $service->ticket_id = $ticket->id;
            $service->employee = Input::get('employee');
            $service->save();
            return $service;
        }
    }

    public function update($id) {
        $service = Service::findOrFail($id);
        $service->finish();
        $service->save();
        return $service;
    }

}