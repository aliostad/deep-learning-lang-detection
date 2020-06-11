<?php
use Dominio\Bean\Disciplina;
use Dominio\Facade\DisciplinaFacade;
use Dominio\GerenciadorConexao;
use Dominio\ArrayDatabaseConfig;
/**
 * Description of TestDisciplina
 *
 * @author lazaro
 */
class TestDisciplina extends PHPUnit_Framework_TestCase {
    /**
     * @test
     */
    public function limparBancoDeDados() {
        $gerenciadorConexao = new GerenciadorConexao();
        $gerenciadorConexao->abrirConexao(ArrayDatabaseConfig::obterDatabaseConfig());

        $entityManager = $gerenciadorConexao->obterObjetoConexao();
        $entityManager->getConnection()->query('START TRANSACTION; SET FOREIGN_KEY_CHECKS=0;TRUNCATE disciplina; SET FOREIGN_KEY_CHECKS=1; COMMIT;');
    }
    
    /**
     * @test
     */
    public function deveAdicionarDisciplina() {
        $disciplina = new Disciplina(NULL, "Algoritmos I");
        $curriculoFacade = new Dominio\Facade\CurriculoFacade();
        $curriculo = $curriculoFacade->buscarPorId(1);
        $departamentoFacade = new Dominio\Facade\DepartamentoFacade();
        $departamento = $departamentoFacade->buscarPorId(1);
        $disciplina->setCurriculo($curriculo);
        $disciplina->setDepartamento($departamento);
        $facade = new DisciplinaFacade();
        $this->assertTrue($facade->salvar($disciplina));
    }
    /**
     * @test
     */
    public function deveAdicionarDisciplina2() {
        $disciplina = new Disciplina(NULL, "Linguagem de Programação");
        $curriculoFacade = new Dominio\Facade\CurriculoFacade();
        $curriculo = $curriculoFacade->buscarPorId(1);
        $departamentoFacade = new Dominio\Facade\DepartamentoFacade();
        $departamento = $departamentoFacade->buscarPorId(1);
        $disciplina->setCurriculo($curriculo);
        $disciplina->setDepartamento($departamento);
        $facade = new DisciplinaFacade();
        $this->assertTrue($facade->salvar($disciplina));
    }

    /**
     * @test
     */
    public function deveAlterarDisciplina() {
        $facade = new DisciplinaFacade();
        $disciplina= new \Dominio\Bean\Disciplina();

        $disciplina = $facade->buscarPorId(2);

        $disciplina->setNome("Pesquisa Operacional");

        $this->assertTrue($facade->atualizar($disciplina));
    }
    
    /**
     * @test
     */
    public function deveBuscarDisciplinaPorNome(){
        $facade = new DisciplinaFacade();
        
        $disciplina = new Doctrine\Common\Collections\ArrayCollection();
        
        $disciplina = $facade->buscarPorNome("Pesquisa Operacional");
        
        $this->assertEquals(count($disciplina), 1);
    }
    
    /**
     * @test
     */
    public function deveBuscarTodosOsDisciplinas(){
        $facade = new DisciplinaFacade();
        
        $disciplinas = new Doctrine\Common\Collections\ArrayCollection();
        
        $this->assertEquals(count($facade->buscarTodos()), 2);
    }
    
    /**
     * @test
     */
    public function deveExcluirDisciplina(){
        $facade = new DisciplinaFacade();
        $this->assertTrue($facade->excluir(2));        
    }
}
