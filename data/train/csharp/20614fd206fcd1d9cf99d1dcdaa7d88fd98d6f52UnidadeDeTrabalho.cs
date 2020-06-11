using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TrabalhoASW.Models.Repository
{
    public class UnidadeDeTrabalho
    {
        private bool disposed = false;
        ContextoBD context = new ContextoBD();
        private AlunoRepository alunoRepository;
        private AvaliacaoRepository avaliacaoRepository;
        private CoordenadorRepository coordenadorRepository;
        private CursoRepository cursoRepository;
        private DisciplinaRepository disciplinaRepository;
        private EnderecoRepository enderecoRepository;
        private MatriculaRepository matriculaRepository;
        private NotaRepository notaRepository;
        private PeriodoRepository periodoRepository;
        private PessoaRepository pessoaRepository;
        private ProfessorRepository professorRepository;
        private TurmaRepository turmaRepository;
        private UniversidadeRepository universidadeRepository;

        public AlunoRepository AlunoRepository
        {
            get
            {
                if (alunoRepository == null)
                {
                    alunoRepository = new AlunoRepository(context);
                }
                return alunoRepository;
            }
        }
        public AvaliacaoRepository AvaliacaoRepository
        {
            get
            {
                if (avaliacaoRepository == null)
                {
                    avaliacaoRepository = new AvaliacaoRepository(context);
                }
                return avaliacaoRepository;
            }
        }

        public CoordenadorRepository CoordenadorRepository
        {
            get
            {
                if (coordenadorRepository == null)
                {
                    coordenadorRepository = new CoordenadorRepository(context);
                }
                return coordenadorRepository;
            }
        }
        public CursoRepository CursoRepository
        {
            get
            {
                if (cursoRepository == null)
                {
                    cursoRepository = new CursoRepository(context);
                }
                return cursoRepository;
            }
        }

        public DisciplinaRepository DisciplinaRepository
        {
            get
            {
                if (disciplinaRepository == null)
                {
                    disciplinaRepository = new DisciplinaRepository(context);
                }
                return disciplinaRepository;
            }
        }

        public EnderecoRepository EnderecoRepository
        {
            get
            {
                if (enderecoRepository == null)
                {
                    enderecoRepository = new EnderecoRepository(context);
                }
                return enderecoRepository;
            }
        }

        public MatriculaRepository MatriculaRepository
        {
            get
            {
                if (matriculaRepository == null)
                {
                    matriculaRepository = new MatriculaRepository(context);
                }
                return matriculaRepository;
            }
        }

        public NotaRepository NotaRepository
        {
            get
            {
                if (notaRepository == null)
                {
                    notaRepository = new NotaRepository(context);
                }
                return notaRepository;
            }
        }

        public PeriodoRepository PeriodoRepository
        {
            get
            {
                if (periodoRepository == null)
                {
                    periodoRepository = new PeriodoRepository(context);
                }
                return periodoRepository;
            }
        }

        public PessoaRepository PessoaRepository
        {
            get
            {
                if (pessoaRepository == null)
                {
                    pessoaRepository = new PessoaRepository(context);
                }
                return pessoaRepository;
            }
        }

        public ProfessorRepository ProfessorRepository
        {
            get
            {
                if (professorRepository == null)
                {
                    professorRepository = new ProfessorRepository(context);
                }
                return professorRepository;
            }
        }

        public TurmaRepository TurmaRepository
        {
            get
            {
                if (turmaRepository == null)
                {
                    turmaRepository = new TurmaRepository(context);
                }
                return turmaRepository;
            }
        }

        public UniversidadeRepository UniversidadeRepository
        {
            get
            {
                if (universidadeRepository == null)
                {
                    universidadeRepository = new UniversidadeRepository(context);
                }
                return universidadeRepository;
            }
        }

        public void salva()
        {
            context.SaveChanges();
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    context.Dispose();
                }
            }
            this.disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}