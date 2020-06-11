<?php 
class apiActions extends classes\Classes\Actions{
    protected $permissions = array(
        "api_public" => array(
            "nome"      => "api_public",
            "label"     => "Acesso ao api",
            "descricao" => "Acesso público ao plugin api",
            "default"   => "s",
        ),
         "api_admin" => array(
            "nome"      => "api_admin",
            "label"     => "Administrar api",
            "descricao" => "Permite gerenciar (adicionar, visualizar, editar e apagar) os dados do plugin api",
            "default"   => "n",
        ),
        
    );
    
    protected $actions = array( 
        
        "api/index/index" => array(
            "label" => "api", "publico" => "s", "default_yes" => "s","default_no" => "n",
            "permission" => "api_public",
            "menu" => array('api/app/manage'),
            "breadscrumb" => array("api/index/index", )
        ),
        
        "api/app/manage" => array(
            "label" => "Minha API", "publico" => "n", "default_yes" => "s","default_no" => "n",
            "permission" => "api_public",
            "breadscrumb" => array("api/index/index", "api/app/manage")
        ),
        
        'api/app/index' => array(
            'label' => 'app', 'publico' => 'n', 'default_yes' => 's','default_no' => 'n',
            'permission' => 'api_admin',
            'menu' => array('Página Principal' => 'api/index/index', 'api/app/formulario')
        ),
        
        'api/app/formulario' => array(
            'label' => 'Criar app', 'publico' => 'n', 'default_yes' => 's','default_no' => 'n',
            'permission' => 'api_admin',
            'menu' => array('Voltar' => 'api/app/index')
        ),
        
        'api/app/show' => array(
            'label' => 'Visualizar app', 'publico' => 'n', 'default_yes' => 's','default_no' => 'n',
            'permission' => 'api_admin', 'needcod' => true,
            'menu' => array('api/app/index', 'Ações' => array('Editar' => 'api/app/edit', 'Excluir' => 'api/app/apagar')),
            "breadscrumb" => array("api/index/index", "api/app/manage", "api/app/show")
        ),
        
        'api/app/edit' => array(
            'label' => 'Editar app', 'publico' => 'n', 'default_no' => 's','default_no' => 'n', 
            'permission' => 'api_admin', 'needcod' => true,
            'menu' => array('api/app/index', 'Voltar para app' => 'api/app/show'),
            "breadscrumb" => array("api/index/index", "api/app/manage", "api/app/show", 'api/app/edit')
        ),

        'api/app/apagar' => array(
            'label' => 'Excluir app', 'publico' => 'n', 'default_no' => 's','default_no' => 'n',
            'permission' => 'api_admin', 'needcod' => true,
            'menu' => array()
        ),

    
        
        'api/publisher/index' => array(
            'label' => 'publisher', 'publico' => 'n', 'default_yes' => 's','default_no' => 'n',
            'permission' => 'api_admin',
            'menu' => array('Página Principal' => 'api/index/index', 'api/publisher/formulario')
        ),
        
        'api/publisher/formulario' => array(
            'label' => 'Criar publisher', 'publico' => 'n', 'default_yes' => 's','default_no' => 'n',
            'permission' => 'api_admin',
            'menu' => array('Voltar' => 'api/publisher/index')
        ),
        
        'api/publisher/show' => array(
            'label' => 'Visualizar publisher', 'publico' => 'n', 'default_yes' => 's','default_no' => 'n',
            'permission' => 'api_admin', 'needcod' => true,
            'menu' => array('api/publisher/index', 'Ações' => array('Editar' => 'api/publisher/edit', 'Excluir' => 'api/publisher/apagar'))
        ),
        
        'api/publisher/edit' => array(
            'label' => 'Editar publisher', 'publico' => 'n', 'default_no' => 's','default_no' => 'n', 
            'permission' => 'api_admin', 'needcod' => true,
            'menu' => array('api/publisher/index', 'Voltar para publisher' => 'api/publisher/show')
        ),

        'api/publisher/apagar' => array(
            'label' => 'Excluir publisher', 'publico' => 'n', 'default_no' => 's','default_no' => 'n',
            'permission' => 'api_admin', 'needcod' => true,
            'menu' => array()
        ),

    
        
        'api/publication/index' => array(
            'label' => 'publication', 'publico' => 'n', 'default_yes' => 's','default_no' => 'n',
            'permission' => 'api_admin',
            'menu' => array('Página Principal' => 'api/index/index', 'api/publication/formulario')
        ),
        
        'api/publication/formulario' => array(
            'label' => 'Criar publication', 'publico' => 'n', 'default_yes' => 's','default_no' => 'n',
            'permission' => 'api_admin',
            'menu' => array('Voltar' => 'api/publication/index')
        ),
        
        'api/publication/show' => array(
            'label' => 'Visualizar publication', 'publico' => 'n', 'default_yes' => 's','default_no' => 'n',
            'permission' => 'api_admin', 'needcod' => true,
            'menu' => array('api/publication/index', 'Ações' => array('Editar' => 'api/publication/edit', 'Excluir' => 'api/publication/apagar'))
        ),
        
        'api/publication/edit' => array(
            'label' => 'Editar publication', 'publico' => 'n', 'default_no' => 's','default_no' => 'n', 
            'permission' => 'api_admin', 'needcod' => true,
            'menu' => array('api/publication/index', 'Voltar para publication' => 'api/publication/show')
        ),

        'api/publication/apagar' => array(
            'label' => 'Excluir publication', 'publico' => 'n', 'default_no' => 's','default_no' => 'n',
            'permission' => 'api_admin', 'needcod' => true,
            'menu' => array()
        ),

    
        
        'api/frequence/index' => array(
            'label' => 'frequence', 'publico' => 'n', 'default_yes' => 's','default_no' => 'n',
            'permission' => 'api_admin',
            'menu' => array('Página Principal' => 'api/index/index', 'api/frequence/formulario')
        ),
        
        'api/frequence/formulario' => array(
            'label' => 'Criar frequence', 'publico' => 'n', 'default_yes' => 's','default_no' => 'n',
            'permission' => 'api_admin',
            'menu' => array('Voltar' => 'api/frequence/index')
        ),
        
        'api/frequence/show' => array(
            'label' => 'Visualizar frequence', 'publico' => 'n', 'default_yes' => 's','default_no' => 'n',
            'permission' => 'api_admin', 'needcod' => true,
            'menu' => array('api/frequence/index', 'Ações' => array('Editar' => 'api/frequence/edit', 'Excluir' => 'api/frequence/apagar'))
        ),
        
        'api/frequence/edit' => array(
            'label' => 'Editar frequence', 'publico' => 'n', 'default_no' => 's','default_no' => 'n', 
            'permission' => 'api_admin', 'needcod' => true,
            'menu' => array('api/frequence/index', 'Voltar para frequence' => 'api/frequence/show')
        ),

        'api/frequence/apagar' => array(
            'label' => 'Excluir frequence', 'publico' => 'n', 'default_no' => 's','default_no' => 'n',
            'permission' => 'api_admin', 'needcod' => true,
            'menu' => array()
        ),

    
    );
    
}
