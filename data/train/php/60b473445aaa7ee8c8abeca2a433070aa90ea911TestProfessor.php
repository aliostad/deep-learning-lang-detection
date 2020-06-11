<?php
use Dominio\Bean\Professor;
use Dominio\Facade\ProfessorFacade;
use Dominio\GerenciadorConexao;
use Dominio\ArrayDatabaseConfig;
/**
 * Description of TestProfessor
 *
 * @author lazaro
 */
class TestProfessor extends PHPUnit_Framework_TestCase {
    /**
     * @test
     */
    public function limparBancoDeDados() {
        $gerenciadorConexao = new GerenciadorConexao();
        $gerenciadorConexao->abrirConexao(ArrayDatabaseConfig::obterDatabaseConfig());

        $entityManager = $gerenciadorConexao->obterObjetoConexao();
        $entityManager->getConnection()->query('START TRANSACTION; SET FOREIGN_KEY_CHECKS=0; TRUNCATE chefe;'
                . 'TRUNCATE disciplina; TRUNCATE doc_programa; TRUNCATE ementa;'
                . 'TRUNCATE professor; TRUNCATE programa; SET FOREIGN_KEY_CHECKS=1; COMMIT;');
    }
    
    /**
     * @test
     */
    public function deveAdicionarProfessor() {
        $professor = new Professor(NULL, "Geraldo Braz");
        $facade = new ProfessorFacade();
        $this->assertTrue($facade->salvar($professor));
    }
    /**
     * @test
     */
    public function deveAdicionarProfessor2() {
        $professor = new Professor(NULL, "Alexandre Oliveira");
        $facade = new ProfessorFacade();
        $this->assertTrue($facade->salvar($professor));
    }

    /**
     * @test
     */
    public function deveAlterarProfessor() {
        $facade = new ProfessorFacade();
        $professor= new \Dominio\Bean\Professor();

        $professor = $facade->buscarPorId(2);

        $professor->setNome("Alexandre Cesar Muniz de Oliveira");

        $this->assertTrue($facade->atualizar($professor));
    }
    
    /**
     * @test
     */
    public function deveBuscarProfessorPorNome(){
        $facade = new ProfessorFacade();
        
        $professor = new Professor();
        
        $professor = $facade->buscarPorNome("Alexandre");
        
        $this->assertEquals("Alexandre Cesar Muniz de Oliveira", $professor[0]->getNome());
    }
    
    /**
     * @test
     */
    public function deveBuscarTodosOsProfessors(){
        $facade = new ProfessorFacade();
        
        $professors = new Doctrine\Common\Collections\ArrayCollection();
        
        $this->assertEquals(count($facade->buscarTodos()), 2);
    }
    
    /**
     * @test
     */
    public function deveExcluirProfessor(){
        $facade = new ProfessorFacade();
        $this->assertTrue($facade->excluir(2));        
    }
}
