<?php
require_once APPPATH.'controllers/seo/seo'.EXT;

class Permission_copy extends Seo
{
    public function  __construct()
    {
        parent::__construct();
        $this->load->model('permission_copy_model');
        $this->load->library('form_validation');
    }

    public function permission_copy_show()
    {
        $this->template->write_view('content', 'seo/service_company/permission_copy');
        $this->template->render();
    }

    public function permission_copy_save()
    {
        $permission_type =$this->input->post('permission_type');
        $copy_source =$this->input->post('copy_source');
        $copy_target =$this->input->post('copy_target');
        $cover_type  =$this->input->post('cover_type');

        $rules = array(
            array(
                'field' => 'copy_source',
                'label' => lang('copy_source'),
                'rules' => 'trim|required',
            ),
            array(
                'field' => 'copy_target',
                'label' => lang('copy_target'),
                'rules' => 'trim|required',
            ),
        );
    
        $this->form_validation->set_rules($rules);
        if ($this->form_validation->run() == FALSE)
        {
            $error = validation_errors();
            echo $this->create_json(0, $error);
            return;
        }

        if ($permission_type == 0 && $cover_type == 0)
        {
            $show_types = $this->permission_copy_model->permission_type_first($copy_source);
            $show_del = $this->permission_copy_model->permission_copy_del($copy_target);
            $show_cover = $this->permission_copy_model->permission_type_cover($show_types, $copy_target);
            echo $this->create_json(1, lang('ok'));
        }
        else if ($permission_type == 0 && $cover_type == 1)
        {
            $show_types = $this->permission_copy_model->permission_type_two($copy_source,$copy_target);
            $show_del = $this->permission_copy_model->permission_copy_del($copy_target);
            $show_cover = $this->permission_copy_model->permission_type_cover2($show_types, $copy_target);
            echo $this->create_json(1, lang('ok'));
        }
        else if ($permission_type == 1 && $cover_type == 0)
        {
            $show_types = $this->permission_copy_model->permission_type_three($copy_source);
            $show_del = $this->permission_copy_model->permission_copy_delthree($copy_target);
            $show_cover = $this->permission_copy_model->permission_type_coverthree($show_types, $copy_target);
            echo $this->create_json(1, lang('ok'));
        }
        else if ($permission_type == 1 && $cover_type == 1)
        {
            $show_types = $this->permission_copy_model->permission_type_three_two($copy_source,$copy_target);
            $show_del = $this->permission_copy_model->permission_copy_delthree($copy_target);
            $show_cover = $this->permission_copy_model->permission_type_coverthree($show_types, $copy_target);
            echo $this->create_json(1, lang('ok'));
        }
        else if ($permission_type == 2 && $cover_type == 0)
        {
            $show_types = $this->permission_copy_model->permission_type_four($copy_source);
            $show_del = $this->permission_copy_model->permission_copy_delfour($copy_target);
            $show_cover = $this->permission_copy_model->permission_type_coverfour($show_types, $copy_target);
            echo $this->create_json(1, lang('ok'));
        }
        else if ($permission_type == 2 && $cover_type == 1)
        {
            $show_types = $this->permission_copy_model->permission_type_four_two($copy_source,$copy_target);
            $show_del = $this->permission_copy_model->permission_copy_delfour($copy_target);
            $show_cover = $this->permission_copy_model->permission_type_coverfour($show_types, $copy_target);
            echo $this->create_json(1, lang('ok'));
        }

    }

}
