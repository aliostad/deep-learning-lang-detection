<?php

/**
 * Description of TestCurso
 *
 * @author lazaro
 */
use Dominio\Facade\CursoFacade;
use Dominio\GerenciadorConexao;
use Dominio\ArrayDatabaseConfig;

class TestCurso extends PHPUnit_Framework_TestCase {

    /**
     * @test
     */
    public function limparBancoDeDados() {
        $gerenciadorConexao = new GerenciadorConexao();
        $gerenciadorConexao->abrirConexao(ArrayDatabaseConfig::obterDatabaseConfig());

        $entityManager = $gerenciadorConexao->obterObjetoConexao();
        $entityManager->getConnection()->query('START TRANSACTION; SET FOREIGN_KEY_CHECKS=0; TRUNCATE chefe; TRUNCATE curriculo; '
                . 'TRUNCATE curso; TRUNCATE disciplina; TRUNCATE doc_programa; TRUNCATE ementa;'
                . 'TRUNCATE professor; TRUNCATE programa; SET FOREIGN_KEY_CHECKS=1; COMMIT;');
    }

    /**
     * @test
     */
    public function deveAdicionarCurso() {
        $nome = "Ciência da Computação";

        $facade = new CursoFacade();
        $id = $facade->salvarCurso($nome);
        $this->assertEquals(1, $id);
    }
    /**
     * @test
     */
    public function deveAdicionarCurso2() {
        $nome = "Ciência da Computação";

        $facade = new CursoFacade();
        $id = $facade->salvarCurso($nome);
        $this->assertEquals(2, $id);
    }

    /**
     * @test
     */
    public function deveAlterarCurso() {
        $facade = new CursoFacade();
        $curso = new \Dominio\Bean\Curso();

        $curso = $facade->buscarCursoPorId(2);

        $curso->setNome("Computação");
        $algo = $curso->getCurriculo();

        $this->assertTrue($facade->alterarCurso($curso->getId(), $curso->getNome()));
    }
    
    /**
     * @test
     */
    public function deveBuscarCursoPorNome(){
        $facade = new CursoFacade();
        
        $curso = new Doctrine\Common\Collections\ArrayCollection();
        
        $cursos = $facade->buscarCursoPorNome("Computação");
        
        $this->assertEquals(count($cursos), 2);
    }
    
    /**
     * @test
     */
    public function deveBuscarTodosOsCursos(){
        $facade = new CursoFacade();
        
        $cursos = new Doctrine\Common\Collections\ArrayCollection();
        
        $this->assertEquals(count($facade->buscarTodosOsCursos()), 2);
    }
    
    /**
     * @test
     */
    public function deveExcluirCurso(){
        $facade = new CursoFacade();
        $this->assertTrue($facade->excluirCurso(2));        
    }

}
