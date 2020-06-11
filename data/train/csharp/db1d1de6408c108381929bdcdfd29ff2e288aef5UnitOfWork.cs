using Fiap.RH.Sistema.Contratacao.Dominio;
using Fiap.RH.Sistema.Contratacao.Persistencia.Repositories;
using System;

namespace Fiap.RH.Sistema.Contratacao.Persistencia.UnitsOfWork
{
    public class UnitOfWork : IDisposable
    {
        // IMPORTANTE! recupera uma conexao do pool
        private Entities _persistencia = new Entities();

        private IGenericRepository<Candidato> _candidatoRepository;
        private IGenericRepository<Fabrica> _fabricaRepository;
        private IGenericRepository<Aula> _aulaRepository;
        private IGenericRepository<CandidatoAula> _candidatoAulaRepository;

        private IGenericRepository<PerfilProfissional> _perfilProfissionalRepository;
        private IGenericRepository<Unidade> _unidadeRepository;
        private IGenericRepository<Curso> _cursoRepository;

        private IGenericRepository<AvaliacaoComportamental> _avaliacaoComportamentalRepository;
        private IGenericRepository<Relatorio> _relatorioRepository;
        private IGenericRepository<Habilidade> _habilidadeRepository;
        private IRelatorioHabilidadeRepository _relatorioHabilidadeRepository;
        private IGenericRepository<Login> _loginRepository;

        public IGenericRepository<Candidato> CandidatoRepository
        {
            get
            {
                if(_candidatoRepository == null)
                {
                    _candidatoRepository = new GenericRepository<Candidato>(_persistencia);
                }
                return _candidatoRepository;
            }
        }

        public IGenericRepository<Fabrica> FabricaRepository
        {
            get
            {
                if(_fabricaRepository == null)
                {
                    _fabricaRepository = new GenericRepository<Fabrica>(_persistencia);
                }
                return _fabricaRepository;
            }
        }

        public IGenericRepository<Aula> AulaRepository
        {
            get
            {
                if (_aulaRepository == null)
                {
                    _aulaRepository = new GenericRepository<Aula>(_persistencia);
                }
                return _aulaRepository;
            }
        }

        public IGenericRepository<CandidatoAula> CandidatoAulaRepository
        {
            get
            {
                if (_candidatoAulaRepository == null)
                {
                    _candidatoAulaRepository = new GenericRepository<CandidatoAula>(_persistencia);
                }
                return _candidatoAulaRepository;
            }
        }

        public IGenericRepository<PerfilProfissional> PerfilProfissionalRepository
        {
            get
            {
                if (_perfilProfissionalRepository == null)
                {
                    _perfilProfissionalRepository = new GenericRepository<PerfilProfissional>(_persistencia);
                }
                return _perfilProfissionalRepository;
            }
        }

        public IGenericRepository<Unidade> UnidadeRepository
        {
            get
            {
                if (_unidadeRepository == null)
                {
                    _unidadeRepository = new GenericRepository<Unidade>(_persistencia);
                }
                return _unidadeRepository;
            }
        }

        public IGenericRepository<Curso> CursoRepository
        {
            get
            {
                if (_cursoRepository == null)
                {
                    _cursoRepository = new GenericRepository<Curso>(_persistencia);
                }
                return _cursoRepository;
            }
        }

        public IGenericRepository<AvaliacaoComportamental> AvaliacaoComportamentalRepository
        {
            get
            {
                if (_avaliacaoComportamentalRepository == null)
                {
                    _avaliacaoComportamentalRepository = new GenericRepository<AvaliacaoComportamental>(_persistencia);
                }
                return _avaliacaoComportamentalRepository;
            }
        }

        public IGenericRepository<Relatorio> RelatorioRepository
        {
            get
            {
                if(_relatorioRepository == null)
                {
                    _relatorioRepository = new GenericRepository<Relatorio>(_persistencia);
                }
                return _relatorioRepository;
            }
        }

        public IGenericRepository<Habilidade> HabilidadeRepository
        {
            get
            {
                if(_habilidadeRepository == null)
                {
                    _habilidadeRepository = new GenericRepository<Habilidade>(_persistencia);
                }
                return _habilidadeRepository;
            }
        }

        public IRelatorioHabilidadeRepository RelatorioHabilidadeRepository
        {
            get
            {
                if(_relatorioHabilidadeRepository == null)
                {
                    _relatorioHabilidadeRepository = new RelatorioHabilidadeRepository(_persistencia);
                }
                return _relatorioHabilidadeRepository;
            }
        }

        public IGenericRepository<Login> LoginRepository
        {
            get
            {
                if (_loginRepository == null)
                {
                    _loginRepository = new GenericRepository<Login>(_persistencia);
                }
                return _loginRepository;
            }
        }

        public void Save()
        {
            _persistencia.SaveChanges();
        }

        public void Dispose()
        {
            if(_persistencia != null)
            {
                // IMPORTANTE! devolve a conexao ao pool
                _persistencia.Dispose();
            }
            GC.SuppressFinalize(this);
        }
    }
}
