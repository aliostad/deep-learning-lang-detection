<?php
// ///////////////////////////////
// API APIS
//
// - Inclui (i_api)
// - Exclui (x_api)
// - Edita  (e_api)
// - Lista  (l_api)

if(isset($_POST['acao'])) {

	$api    = new api_apis();
	$params	= array();
	$common	= new common();

	//INCLUIR
	if($_POST['acao']=='i_api')  {
		$params['api_descricao']   = $common->prepara_dado($_POST['api_descricao'], 0);
		$params['api_arquivo']     = $common->prepara_dado($_POST['api_arquivo'], 0);
		$params['api_link']        = $common->prepara_dado($_POST['api_link'], 0);
		$params['api_grupo']       = $common->prepara_dado($_POST['api_grupo'], 0);

		echo $api->insere($app, $params);
		exit;
	}

	//EXCLUIR
	if ($_POST['acao']=='x_api') {
		$params['ApiID']    = $common->prepara_dado($_POST['ApiID'], 0);

		echo $api->exclui($app, $params);
		exit;
	}

	//EDITAR
	if ($_POST['acao']=='e_api') {
		$params['ApiID']           = $common->prepara_dado($_POST['ApiID'], 0);
		$params['api_descricao']   = $common->prepara_dado($_POST['api_descricao'], 0);
		$params['api_arquivo']     = $common->prepara_dado($_POST['api_arquivo'], 0);
		$params['api_link']        = $common->prepara_dado($_POST['api_link'], 0);
		$params['api_grupo']       = $common->prepara_dado($_POST['api_grupo'], 0);		

		echo $api->edita($app, $params);
		exit;
	}
	
	//LISTAR
	if ($_POST['acao']=='l_api') {
		$params['qtdInicio'] = $common->prepara_dado($_POST['qtdInicio'], 0);
		$params['strBusca']  = $common->prepara_dado($_POST['strBusca'], 0);
		
		echo $api->lista($app, $params);
		exit;
	}

	//PEGA DADOS
	if ($_POST['acao']=='dados_api') {
		$params['ApiID'] = $common->prepara_dado($_POST['ApiID'], 0);
		
		echo $api->pega_dados($app, $params);
		exit;
	}	
	
}


class api_apis extends aplicacao {

    // Insere.
    public function insere ($app = false, $params) {
		$mysql = new sqli();
		$sSql = "INSERT INTO tbl_apis 
					(api_descricao, api_arquivo, api_status, api_link, api_grupo)
					VALUES
					('".$params['api_descricao']."', '".$params['api_arquivo']."', 1, '".$params['api_link']."', '".$params['api_grupo']."')";

		if($id = $mysql->executa($sSql)) {            
			return "1";
		} else {
			return "0";
		}
	}


    // Exclui.
    public function exclui ( $app = false, $params ) {
        $mysql = new sqli();
        $sSql = "UPDATE tbl_apis SET api_status = 0 WHERE ApiID = " . $params['ApiID'];
                                     
        if($mysql->executa($sSql)) {
			return '1';
		}
    }


    // Edita.
    public function edita ($app = false, $params) {
        $mysql = new sqli();
        $sSql = "UPDATE tbl_apis SET
                    api_descricao  = '" . $params['api_descricao'] . "',
					api_arquivo    = '" . $params['api_arquivo'] . "',
					api_link       = '" . $params['api_link'] . "',
					api_grupo      = '" . $params['api_grupo'] . "'
                  WHERE ApiID 	   = " . $params['ApiID'];

        $strReturn = $mysql->executa($sSql);
        echo $strReturn;
    }
	
    // Lista.
    public function lista ($app = false, $params) {
        $mysql = new sqli();
		
		if($params['qtdInicio'] == "") {
			$qtdInicio = 0;
		} else {
			$qtdInicio = $params['qtdInicio'];
		}

		if($params['strBusca'] != "") {
			$strBusca = " AND api_descricao LIKE '" . $params['strBusca'] . "%'";
		} else {
			$strBusca = "";
		}
		
        $sSql = "SELECT * 
					FROM tbl_apis
					WHERE api_status = 1  " . $strBusca . "
					ORDER BY api_descricao 
					LIMIT " . $qtdInicio . ", 20";

		$result = $mysql->executa($sSql);			

		if($result->num_rows > 0) {	
			$item = 0;
			while($api = $result->fetch_object()) {
				$retorno->api[$item]->ApiID 	    = $api->ApiID;
				$retorno->api[$item]->api_descricao = $api->api_descricao;
				$retorno->api[$item]->api_arquivo   = $api->api_arquivo;
				$retorno->api[$item]->api_link	    = $api->api_link;
				$retorno->api[$item]->api_grupo	    = $api->api_grupo;
				
				$item++;
			}
			return json_encode($retorno);
		} else {
			return "0";
		}	
		
    }	
	
    // Pega dados.
    public function pega_dados ($app = false, $params) {
        $mysql = new sqli();
        $sSql = "SELECT * FROM tbl_apis
                  WHERE ApiID = " . $params['ApiID'];

        $result = $mysql->executa($sSql);
		
		if($result->num_rows > 0) {
			$api = $result->fetch_object();
			$retorno->ApiID 		= $api->ApiID;
			$retorno->api_descricao = $api->api_descricao;
			$retorno->api_arquivo 	= $api->api_arquivo;
			$retorno->api_link	    = $api->api_link;
			$retorno->api_grupo	    = $api->api_grupo;
				
			return json_encode($retorno);
			
		} else {
			return "0";
			
		} 

    }	
	
}

?>