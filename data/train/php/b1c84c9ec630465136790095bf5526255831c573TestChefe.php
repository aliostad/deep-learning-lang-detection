<?php
use Dominio\Bean\Chefe;
use Dominio\Facade\ChefeFacade;
use Dominio\GerenciadorConexao;
use Dominio\ArrayDatabaseConfig;

/**
 * Description of TestChefe
 *
 * @author lazaro
 */
class TestChefe extends PHPUnit_Framework_TestCase {
    /**
     * @test
     */
    public function limparBancoDeDados() {
        $gerenciadorConexao = new GerenciadorConexao();
        $gerenciadorConexao->abrirConexao(ArrayDatabaseConfig::obterDatabaseConfig());

        $entityManager = $gerenciadorConexao->obterObjetoConexao();
        $entityManager->getConnection()->query('START TRANSACTION; SET FOREIGN_KEY_CHECKS=0; TRUNCATE chefe;'
                . 'TRUNCATE disciplina; TRUNCATE doc_programa; TRUNCATE ementa;'
                . 'TRUNCATE programa; SET FOREIGN_KEY_CHECKS=1; COMMIT;');
    }
    
    /**
     * @test
     */
    public function deveAdicionarChefe() {
        $chefe = new Chefe();
        $professorFacade = new Dominio\Negocio\ProfessorNegocio();
        $departamentoFacade = new Dominio\Negocio\DepartamentoNegocio();
        $professor = $professorFacade->buscarPorId(1);
        $departamento = $departamentoFacade->buscarPorId(1);
        $chefe->setProfessor($professor);
        $chefe->setDepartamento($departamento);
        $facade = new ChefeFacade();
        $this->assertTrue($facade->salvar($chefe));
    }
    /**
     * @test
     */
    public function deveAdicionarChefe2() {
        $chefe = new Chefe(NULL);
        $professorFacade = new \Dominio\Facade\ProfessorFacade();
        $departamentoFacade = new Dominio\Facade\DepartamentoFacade();
        $professor = $professorFacade->buscarPorId(1);
        $departamento = $departamentoFacade->buscarPorId(1);
        $chefe->setProfessor($professor);
        $chefe->setDepartamento($departamento);
        $facade = new ChefeFacade();
        $this->assertTrue($facade->salvar($chefe));
    }

    /**
     * @test
     */
    public function deveAlterarChefe() {
        $facade = new ChefeFacade();
        $chefe= new \Dominio\Bean\Chefe();

        $chefe = $facade->buscarPorId(2);
        $chefe->setProfessor(new Dominio\Bean\Professor(1, "Lázaro Henrique"));

        $this->assertTrue($facade->atualizar($chefe));
    }
    
    /**
     * @test
     */
    public function deveBuscarTodosOsChefes(){
        $facade = new ChefeFacade();
        
        $chefes = new Doctrine\Common\Collections\ArrayCollection();
        
        $this->assertEquals(count($facade->buscarTodos()), 2);
    }
    
    /**
     * @test
     */
    public function deveExcluirChefe(){
        $facade = new ChefeFacade();
        $this->assertTrue($facade->excluir(2));        
    }
}
