package com.siga.fachada;

public interface IFachada {
	
	
	
	public PessoaService pessoaService();
	public AlunoService alunoService();
	public ProfessorService profesorService();
	public DisciplinaService disciplinaService();
	public FoneService foneService();
	public EnderecoService enderecoService();
	public CursoService cursoService();
	public FrequenciaService frequenciaService();
	public PublicacaoService publicacaoService();
	public HistoricoService historicoService();
	public TurmaService turmaService();
	public UsuarioService usuarioService();
	public PerfilService perfilService();

}
