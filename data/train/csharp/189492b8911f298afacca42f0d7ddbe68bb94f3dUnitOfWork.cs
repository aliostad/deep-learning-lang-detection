using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntitiesLayer;
using DL.Repositories;

namespace DL
{
    public class UnitOfWork
        //clase q sirve de transporte
    {
        private RespuestaRepository _respuestaRepository;
        private PreguntaRepository _preguntaRepository;
        private IRepository<Candidato> _candidatoRepository;
        private SolicitudPruebaRepository _solicitudPruebaRepository;
        private PruebaRepository _pruebaRepository;
        private IRepository<Usuario> _usuarioRepository;
        private IRepository<Tecnologia> _tecnologiaRepository;
        private IRepository<Llamada> _llamadaRepository;
        private IRepository<Empleado> _empleadoRepository;
        private IRepository<Proyecto> _proyectoRepository;
        private IRepository<Cliente> _clienteRepository;
        private IRepository<ListasDesplegables> _listasRepository;
        private DatosRepository _datosRepository;
        private Bitacora _bitacora;
        private TecnologiasPorProyectoRepository _tecnologiaPorProyectoRepository;
        private EmpresaRepository _empresa;
        private TecnologiasPorEmpleadoRepository _tecnologiaPorEmpleadoRepository;
        private BitacoraExcepciones _excepciones;
        private PruebaPorCandidatoRepository _pruebaPorCandidatoRepository;
        private ContratarCandidatoRepository _contratarCandidatoRepository;
        private CVRepository _cvRepository;
        private PreguntasPorPruebaRepository _preguntaPorPruebaRepository;
        

        public SolicitudPruebaRepository SolicitudPruebaRepository
        {
            get
            {
                if (this._solicitudPruebaRepository == null)
                {
                    this._solicitudPruebaRepository = new SolicitudPruebaRepository();
                }
                return _solicitudPruebaRepository;
            }
        }

        public PruebaPorCandidatoRepository PruebaPorCandidatoRepository
        {
            get
            {
                if (this._pruebaPorCandidatoRepository == null)
                {
                    this._pruebaPorCandidatoRepository = new PruebaPorCandidatoRepository();
                }
                return _pruebaPorCandidatoRepository;
            }
        }

        public PruebaRepository PruebaRepository
        {
            get
            {
                if (this._pruebaRepository == null)
                {
                    this._pruebaRepository = new PruebaRepository();
                }
                return _pruebaRepository;
            }
        }


        public IRepository<Candidato> CandidatoRepository
        {
            get
            {
                if (this._candidatoRepository == null)
                {
                    this._candidatoRepository = new CandidatoRepository();
                }
                return _candidatoRepository;
            }
        }

        public IRepository<Usuario> UsuarioRepository
        {
            get
            {
                if (this._usuarioRepository == null)
                {
                    this._usuarioRepository = new UsuarioRepository();
                }
                return _usuarioRepository;
            }
        }

        public IRepository<Tecnologia> TecnologiaRepository
        {
            get
            {
                if (this._tecnologiaRepository == null)
                {
                    this._tecnologiaRepository = new TecnologiaRepository();
                }
                return _tecnologiaRepository;
            }
        }

        public IRepository<Llamada> LlamadaRepository
        {
            get
            {
                if (this._llamadaRepository == null)
                {
                    this._llamadaRepository = new LlamadaRepository();
                }
                return _llamadaRepository;
            }
        }

        public IRepository<Empleado> EmpleadoRepository
        {
            get
            {
                if (this._empleadoRepository == null)
                {
                    this._empleadoRepository = new EmpleadoRepository();
                }
                return _empleadoRepository;
            }
        }

        public IRepository<Proyecto> ProyectoRepository
        {
            get
            {
                if (this._proyectoRepository == null)
                {
                    this._proyectoRepository = new ProyectoRepository();
                }
                return _proyectoRepository;
            }
        }

        public IRepository<Cliente> ClienteRepository
        {
            get
            {
                if (this._clienteRepository == null)
                {
                    this._clienteRepository = new ClienteRepository();
                }
                return _clienteRepository;
            }
        }

        public IRepository<ListasDesplegables> ListasRepository
        {
            get
            {
                if (this._listasRepository == null)
                {
                    this._listasRepository = new ListasRepository();
                }
                return _listasRepository;
            }
        }

        public DatosRepository DatosRepository
        {
            get
            {
                if (this._datosRepository == null)
                {
                    this._datosRepository = new DatosRepository();
                }
                return _datosRepository;
            }
        }

        public Bitacora Bitacora
        {
            get
            {
                if (this._bitacora == null)
                {
                    this._bitacora = new Bitacora();
                }
                return _bitacora;
            }
        }
        public TecnologiasPorProyectoRepository TecnologiasPorProyectoRepository
        {
            get 
            {
                if (this._tecnologiaPorProyectoRepository == null)
                {
                    this._tecnologiaPorProyectoRepository = new TecnologiasPorProyectoRepository();
                }
                return _tecnologiaPorProyectoRepository;
            }
        }

        public EmpresaRepository InfoEmpresa
        {
            get
            {
                if (this._empresa == null)
                {
                    this._empresa = new EmpresaRepository();
                }
                return _empresa;
            }
        }

        public TecnologiasPorEmpleadoRepository TecnologiasPorEmpleadoRepository
        {
            get
            {
                if (this._tecnologiaPorEmpleadoRepository == null)
                {
                    this._tecnologiaPorEmpleadoRepository = new TecnologiasPorEmpleadoRepository();
                }
                return _tecnologiaPorEmpleadoRepository;
            }
        }

        public BitacoraExcepciones BitacoraExcepciones
        {
            get
            {
                if (this._excepciones == null)
                {
                    this._excepciones = new BitacoraExcepciones();
                }
                return _excepciones;
            }
        }

        public PreguntaRepository PreguntaRepository
        {
            get 
            {
                if (this._preguntaRepository == null)
                {
                    this._preguntaRepository = new PreguntaRepository();
                }
                return _preguntaRepository;
            }
        }

        public RespuestaRepository RespuestaRepository
        {
            get
            {
                if (this._respuestaRepository == null)
                {
                    this._respuestaRepository = new RespuestaRepository();
                }
                return _respuestaRepository;
            }
        }

        public ContratarCandidatoRepository ContratarCandidatoRepository
        {
            get
            {
                if (this._contratarCandidatoRepository == null)
                {
                    this._contratarCandidatoRepository = new ContratarCandidatoRepository();
                }
                return _contratarCandidatoRepository;
            }
        }

        public CVRepository CVRepository
        {
            get
            {
                if (this._cvRepository == null)
                {
                    this._cvRepository = new CVRepository();
                }
                return _cvRepository;
            }
        }

        public PreguntasPorPruebaRepository PreguntaPorPruebaRepository
        {
            get
            {
                if (this._preguntaPorPruebaRepository == null)
                {
                    this._preguntaPorPruebaRepository = new PreguntasPorPruebaRepository();
                }
                return _preguntaPorPruebaRepository;
            }
        }
    }
}
