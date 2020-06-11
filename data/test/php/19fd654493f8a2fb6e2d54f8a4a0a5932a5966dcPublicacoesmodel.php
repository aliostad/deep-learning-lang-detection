<?php
//defined('BASEPATH') OR exit('No direct script access allowed');

use LabManager\Facade\PublicacaoFacade;
use LabManager\Facade\ProjetoFacade;

use LabManager\Bean\Publicacao;

/**
 * Description of Publicacaomodel
 *
 * @author lazaro
 */
class Publicacoesmodel extends CI_Model {
    public function buscarTodos(){
        $facade = new PublicacaoFacade();
        try{
            $publicacoes = $facade->findAll();
        }  catch (\Exception $ex){
            throw new Exception($ex->getMessage());
        }
        return $publicacoes;
    }
    
    public function buscarTodosPorAno(){
        $facade = new PublicacaoFacade();
        try{
            $publicacoes = $facade->buscarTodosPorAno();
        }  catch (\Exception $ex){
            throw new Exception($ex->getMessage());
        }
        $publicacoesPorAno = array();
        foreach($publicacoes as $publicacao){
            $publicacoesPorAno[$publicacao->getData()->format('Y')][] = $publicacao;
        }
        return $publicacoesPorAno;
    }
    
    public function cadastrar($arrayCadastro){
        $facade = new PublicacaoFacade();
        $publicacao = new Publicacao();
        if(!isset($arrayCadastro['projeto']) || $arrayCadastro['projeto'] == NULL ||$arrayCadastro['projeto'] == 0){
            throw new \Exception('Selecione um projeto para vincular a esta publicação');
        }
        if(!isset($arrayCadastro['titulo']) || $arrayCadastro['titulo'] == NULL){
            throw new \Exception('Dê um nome a sua publicação');
        }
        if(!isset($arrayCadastro['data']) || $arrayCadastro['data'] == NULL){
            throw new \Exception('A publicação precisa ser datada');
        }
        $publicacao->setData(DateTime::createFromFormat('d/m/Y', $arrayCadastro['data']));
        $publicacao->setTitulo($arrayCadastro['titulo']);
        $publicacao->setAutores($arrayCadastro['autores']);
        $publicacao->setLinkDownload($arrayCadastro['link']);
        $publicacao->setImagem($arrayCadastro['capa']);
        
        $facadeProjeto = new ProjetoFacade();
        $projeto = $facadeProjeto->findById($arrayCadastro['projeto']);
        $publicacao->setProjeto($projeto);
        
        try{
            $facade->save($publicacao);
        } catch (Exception $ex) {
            throw new Exception($ex->getMessage());
        }
        return TRUE; 
    }
    
    public function atualizar($arrayCadastro){
        $facade = new PublicacaoFacade();
        $publicacao = new Publicacao();
        
        $publicacao = $facade->findById($arrayCadastro['id']);
        
        if(!isset($arrayCadastro['projeto']) || $arrayCadastro['projeto'] == NULL ||$arrayCadastro['projeto'] == 0){
            throw new \Exception('Selecione um projeto para vincular a esta publicação');
        }
        if(!isset($arrayCadastro['titulo']) || $arrayCadastro['titulo'] == NULL){
            throw new \Exception('Dê um nome a sua publicação');
        }
        if(!isset($arrayCadastro['data']) || $arrayCadastro['data'] == NULL){
            throw new \Exception('A publicação precisa ser datada');
        }
        $publicacao->setData(DateTime::createFromFormat('d/m/Y', $arrayCadastro['data']));
        $publicacao->setTitulo($arrayCadastro['titulo']);
        $publicacao->setAutores($arrayCadastro['autores']);
        $publicacao->setLinkDownload($arrayCadastro['link']);
        $publicacao->setImagem($arrayCadastro['capa']);
        
        $facadeProjeto = new ProjetoFacade();
        $projeto = $facadeProjeto->findById($arrayCadastro['projeto']);
        $publicacao->setProjeto($projeto);
        
        try{
            $facade->update($publicacao);
        } catch (Exception $ex) {
            throw new Exception($ex->getMessage());
        }
        return TRUE; 
    }
    
    public function remover($idPublicacao){
        $facade = new PublicacaoFacade();
        $publicacao = $facade->findById($idPublicacao);
        try{
            $facade->delete($publicacao);
        }  catch (\Exception $ex){
            throw new Exception($ex->getMessage());
        }
    }
    
    public function buscarPorId($idPublicacao){
        $facade = new PublicacaoFacade();
        
        try{
            $publicacao = $facade->findById($idPublicacao);
        }  catch (\Exception $ex){
            throw new Exception($ex->getMessage());
        }
        return $publicacao;
    }
}
