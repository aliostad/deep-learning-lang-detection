<?php

use Dominio\Bean\Departamento;
use Dominio\Facade\DepartamentoFacade;
use Dominio\GerenciadorConexao;
use Dominio\ArrayDatabaseConfig;

/**
 * Description of TestDepartamento
 *
 * @author lazaro
 */
class TestDepartamento extends PHPUnit_Framework_TestCase {

    /**
     * @test
     */
    public function limparBancoDeDados() {
        $gerenciadorConexao = new GerenciadorConexao();
        $gerenciadorConexao->abrirConexao(ArrayDatabaseConfig::obterDatabaseConfig());

        $entityManager = $gerenciadorConexao->obterObjetoConexao();
        $entityManager->getConnection()->query('START TRANSACTION; SET FOREIGN_KEY_CHECKS=0; TRUNCATE chefe;'
                . 'TRUNCATE departamento; TRUNCATE disciplina; TRUNCATE doc_programa; TRUNCATE ementa;'
                . 'TRUNCATE programa; SET FOREIGN_KEY_CHECKS=1; COMMIT;');
    }

    /**
     * @test
     */
    public function deveAdicionarDepartamento() {
        $departamento = new Departamento(NULL, "Departamento de Informática", "DEINF", "deinf@ufma.br", NULL);
        $facade = new DepartamentoFacade();
        $this->assertTrue($facade->salvar($departamento));
    }

    /**
     * @test
     */
    public function deveAdicionarDepartamento2() {
        $departamento = new Departamento(NULL, "Departamento de Matemática", "DEMAT", "demat@ufma.br", NULL);
        $facade = new DepartamentoFacade();
        $this->assertTrue($facade->salvar($departamento));
    }

    /**
     * @test
     */
    public function deveAlterarDepartamento() {
        $facade = new DepartamentoFacade();
        $departamento = new \Dominio\Bean\Departamento();

        $departamento = $facade->buscarPorId(2);

        $departamento->setNome("Departamento de Letras");

        $this->assertTrue($facade->atualizar($departamento));
    }

    /**
     * @test
     */
    public function deveBuscarDepartamentoPorNome() {
        $facade = new DepartamentoFacade();

        $departamento = new Departamento();

        $departamento = $facade->buscarPorNome("Informática");

        $this->assertEquals("Departamento de Informática", $departamento[0]->getNome());
    }

    /**
     * @test
     */
    public function deveBuscarTodosOsDepartamentos() {
        $facade = new DepartamentoFacade();

        $departamentos = new Doctrine\Common\Collections\ArrayCollection();

        $this->assertEquals(count($facade->buscarTodos()), 2);
    }

    /**
     * @test
     */
    public function deveExcluirDepartamento() {
        $facade = new DepartamentoFacade();
        $this->assertTrue($facade->excluir(2));
    }

}
