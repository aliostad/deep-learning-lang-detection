<?php

class Admin extends App_Controller {
    
    function __construct()
    {
        parent::__construct();
        $this->load->model('settings_model');
    }

    function index()
    {
        $this->view();
    }

    function view()
    {
        $this->load->library('table');

        $rows = $this->settings_model->find_all();
        
        if ($rows->num_rows() > 0)
        {
            foreach ($rows->result() as $row)
            {
                $detalles = anchor("admin/settings/{$row->id}/details", 'Detalles');
                $editar   = anchor("admin/settings/{$row->id}/edit", 'Editar');
                $eliminar = anchor("admin/settings/{$row->id}/remove", 'Eliminar');

                $this->table->add_row(array(
                     $row->setting, 
					 $row->title, 
					 $row->type, 
					 $row->default, 
					 $row->value, 
					 $row->options, 
					 $row->is_required, 
					 $row->order,
                     $detalles,
                     $editar,
                     $eliminar
                ));
            }
        }
        else
        {
            $this->table->add_row('No hay registros|colspan="9"'); 
        }

        $this->table->add_heading(array(
             'Setting', 
			 'Title', 
			 'Type', 
			 'Default', 
			 'Value', 
			 'Options', 
			 'Is required',
			 'Order',
             '&nbsp;|colspan="3"'
        ));

        $data['table_settings'] = $this->table->generate(array('class' => 'table-full'));
    
        $this->template->set_content('view_all')
                        ->render($data);
    }

    function create()
    {
        
        
        $this->template->set_content('create')
                        ->render($data);
    }

    function save()
    {
        if ( ! _post('uid'))
        {
            $save = array();
            $save['setting'] = _post('setting');
			$save['uid'] = _uid('settings'); 
			$save['title'] = _post('title');
			$save['uid'] = _uid('settings'); 
			$save['type'] = _post('type');
			$save['uid'] = _uid('settings'); 
			$save['default'] = _post('default');
			$save['uid'] = _uid('settings'); 
			$save['value'] = _post('value');
			$save['uid'] = _uid('settings'); 
			$save['options'] = _post('options');
			$save['uid'] = _uid('settings'); 
			$save['is_required'] = _post('is_required');
			$save['uid'] = _uid('settings'); 
			$save['module'] = _post('module');
			$save['uid'] = _uid('settings'); 
			$save['order'] = _post('order');
			$save['uid'] = _uid('settings');  
        }
        else
        {
            $save['setting'] = _post('setting');
			$save['title'] = _post('title');
			$save['type'] = _post('type');
			$save['default'] = _post('default');
			$save['value'] = _post('value');
			$save['options'] = _post('options');
			$save['is_required'] = _post('is_required');
			$save['module'] = _post('module');
			$save['order'] = _post('order');   
        }

        if ($this->settings_model->save($save))
        {
            Message::success('Guardado', 'settings');
        }

        Message::error('Error', settings);
    }

}