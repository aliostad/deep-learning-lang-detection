using Model.Repositories;
using System;

namespace Model.UnitOfWork
{
    public class UnitOfWork
    {
        private LoggerUtility.ILogger appLogger = LoggerUtility.Logger.GetInstance();

        #region Eventos Repositories
        private Repositories.CatColoniaRepository _catColoniaRepository;
        private Repositories.DerivadoRepository _derivadoRepository;

        public Repositories.DerivadoRepository DerivadoRepository
        {
            get { return _derivadoRepository ?? (_derivadoRepository = new DerivadoRepository(_entities)); }
        }

        private Repositories.CatEstadoRepository _catEstadoRepository;

        public Repositories.CatEstadoRepository CatEstadoRepository
        {
            get { return _catEstadoRepository ?? (_catEstadoRepository = new CatEstadoRepository(_entities)); }
           
        }
        private Repositories.CatMunicipioRepository _catMunicipioRepository;

        public Repositories.CatMunicipioRepository CatMunicipioRepository
        {
            get { return _catMunicipioRepository ?? (_catMunicipioRepository = new CatMunicipioRepository(_entities)); }
        }
        private Repositories.CatPaisRepository _catPaisRepository;

        public Repositories.CatPaisRepository CatPaisRepository
        {
            get { return _catPaisRepository ?? (_catPaisRepository = new CatPaisRepository(_entities)); }
        }
        private Repositories.CatRolesRepository _catRolesRepository;

        public Repositories.CatRolesRepository CatRolesRepository
        {
            get { return _catRolesRepository ?? (_catRolesRepository = new CatRolesRepository(_entities)); }
        }
        private Repositories.CitasRepository _citasRepository;

        public Repositories.CitasRepository CitasRepository
        {
            get { return _citasRepository ?? (_citasRepository = new CitasRepository(_entities)); }
        }
        private Repositories.CobroConsultaRepository _CobroConsultaRepository;

        public Repositories.CobroConsultaRepository CobroConsultaRepository
        {
            get { return _CobroConsultaRepository ?? (_CobroConsultaRepository = new CobroConsultaRepository(_entities)); }
        }
        private Repositories.ConsultoriosRepository _ConsultoriosRepository;

        public Repositories.ConsultoriosRepository ConsultoriosRepository
        {
            get { return _ConsultoriosRepository ?? (_ConsultoriosRepository = new ConsultoriosRepository(_entities)); }
        }
        private Repositories.ConsultoriosTiposRepository _ConsultoriosTiposRepository;

        public Repositories.ConsultoriosTiposRepository ConsultoriosTiposRepository
        {
            get { return _ConsultoriosTiposRepository ?? (_ConsultoriosTiposRepository = new ConsultoriosTiposRepository(_entities)); }
        }
        private Repositories.CostosConsultasFijasRepository _CostosConsultasFijasRepository;

        public Repositories.CostosConsultasFijasRepository CostosConsultasFijasRepository
        {
            get { return _CostosConsultasFijasRepository ?? (_CostosConsultasFijasRepository = new CostosConsultasFijasRepository(_entities)); }
        }
        private Repositories.DatosGeneralesESRepository _DatosGeneralesESRepository;

        public Repositories.DatosGeneralesESRepository DatosGeneralesESRepository
        {
            get { return _DatosGeneralesESRepository ?? (_DatosGeneralesESRepository = new DatosGeneralesESRepository(_entities)); }
        }
        private Repositories.DatosViviendaESRepository _DatosViviendaESRepository;

        public Repositories.DatosViviendaESRepository DatosViviendaESRepository
        {
            get { return _DatosViviendaESRepository ?? (_DatosViviendaESRepository = new DatosViviendaESRepository(_entities)); }
        }
        private Repositories.DependientesEconomicosESRepository _DependientesEconomicosESRepository;

        public Repositories.DependientesEconomicosESRepository DependientesEconomicosESRepository
        {
            get { return _DependientesEconomicosESRepository ?? (_DependientesEconomicosESRepository = new DependientesEconomicosESRepository(_entities)); }
        }
        private Repositories.DiasRepository _DiasRepository;

        public Repositories.DiasRepository DiasRepository
        {
            get { return _DiasRepository ?? (_DiasRepository = new DiasRepository(_entities)); }
        }
        private Repositories.DisponibilidadConsultoriosRepository _DisponibilidadConsultoriosRepository;

        public Repositories.DisponibilidadConsultoriosRepository DisponibilidadConsultoriosRepository
        {
            get { return _DisponibilidadConsultoriosRepository ?? (_DisponibilidadConsultoriosRepository = new DisponibilidadConsultoriosRepository(_entities)); }
        }
        private Repositories.DisponibilidadPsicoterapeutaRepository _DisponibilidadPsicoterapeutaRepository;

        public Repositories.DisponibilidadPsicoterapeutaRepository DisponibilidadPsicoterapeutaRepository
        {
            get { return _DisponibilidadPsicoterapeutaRepository ?? (_DisponibilidadPsicoterapeutaRepository = new DisponibilidadPsicoterapeutaRepository(_entities)); }
        }
        private Repositories.DomicilioESRepository _DomicilioESRepository;

        public Repositories.DomicilioESRepository DomicilioESRepository
        {
            get { return _DomicilioESRepository ?? (_DomicilioESRepository = new DomicilioESRepository(_entities)); }
        }
        private Repositories.EstatusCitasRepository _EstatusCitasRepository;

        public Repositories.EstatusCitasRepository EstatusCitasRepository
        {
            get { return _EstatusCitasRepository ?? (_EstatusCitasRepository = new EstatusCitasRepository(_entities)); }
        }
        private Repositories.EstudioSocioeconomicoRepository _EstudioSocioeconomicoRepository;

        public Repositories.EstudioSocioeconomicoRepository EstudioSocioeconomicoRepository
        {
            get { return _EstudioSocioeconomicoRepository ?? (_EstudioSocioeconomicoRepository = new EstudioSocioeconomicoRepository(_entities)); }
        }
        private Repositories.FechasRepository _FechasRepository;

        public Repositories.FechasRepository FechasRepository
        {
            get { return _FechasRepository ?? (_FechasRepository = new FechasRepository(_entities)); }
        }
        private Repositories.HorarioPsicoterapeutaRepository _HorarioPsicoterapeutaRepository;

        public Repositories.HorarioPsicoterapeutaRepository HorarioPsicoterapeutaRepository
        {
            get { return _HorarioPsicoterapeutaRepository ?? (_HorarioPsicoterapeutaRepository = new HorarioPsicoterapeutaRepository(_entities)); }
        }
        private Repositories.HorariosRepository _HorariosRepository;

        public Repositories.HorariosRepository HorariosRepository
        {
            get { return _HorariosRepository ?? (_HorariosRepository = new HorariosRepository(_entities)); }
        }
        private Repositories.InformacionBienesESRepository _InformacionBienesESRepository;

        public Repositories.InformacionBienesESRepository InformacionBienesESRepository
        {
            get { return _InformacionBienesESRepository ?? (_InformacionBienesESRepository = new InformacionBienesESRepository(_entities)); }
        }
        private Repositories.LogsRepository _LogsRepository;

        public Repositories.LogsRepository LogsRepository
        {
            get { return _LogsRepository ?? (_LogsRepository = new LogsRepository(_entities)); }
        }
        private Repositories.MenuRepository _MenuRepository;

        public Repositories.MenuRepository MenuRepository
        {
            get { return _MenuRepository ?? (_MenuRepository = new MenuRepository(_entities)); }
        }

        private Repositories.MenuUsuarioRepository _MenuUsuarioRepository;

        public Repositories.MenuUsuarioRepository MenuUsuarioRepository
        {
            get { return _MenuUsuarioRepository ?? (_MenuUsuarioRepository = new MenuUsuarioRepository(_entities)); }
        }
        private Repositories.PacientesRepository _PacientesRepository;

        public Repositories.PacientesRepository PacientesRepository
        {
            get { return _PacientesRepository ?? (_PacientesRepository = new PacientesRepository(_entities)); }
        }
        private Repositories.PagoTerapeutasRepository _PagoTerapeutasRepository;

        public Repositories.PagoTerapeutasRepository PagoTerapeutasRepository
        {
            get { return _PagoTerapeutasRepository ?? (_PagoTerapeutasRepository = new PagoTerapeutasRepository(_entities)); }
        }
        private Repositories.PermisosRepository _PermisosRepository;

        public Repositories.PermisosRepository PermisosRepository
        {
            get { return _PermisosRepository ?? (_PermisosRepository = new PermisosRepository(_entities)); }
        }
        private Repositories.PsicoterapeutaRepository _PsicoterapeutaRepository;

        public Repositories.PsicoterapeutaRepository PsicoterapeutaRepository
        {
            get { return _PsicoterapeutaRepository ?? (_PsicoterapeutaRepository = new PsicoterapeutaRepository(_entities)); }
        }
        private Repositories.ResultadosNivelSocioEconomicoRepository _ResultadosNivelSocioEconomicoRepository;

        public Repositories.ResultadosNivelSocioEconomicoRepository ResultadosNivelSocioEconomicoRepository
        {
            get { return _ResultadosNivelSocioEconomicoRepository ?? (_ResultadosNivelSocioEconomicoRepository = new ResultadosNivelSocioEconomicoRepository(_entities)); }
        }
        private Repositories.SaldoIcerpRepository _SaldoIcerpRepository;

        public Repositories.SaldoIcerpRepository SaldoIcerpRepository
        {
            get { return _SaldoIcerpRepository ?? (_SaldoIcerpRepository = new SaldoIcerpRepository(_entities)); }
        }
        private Repositories.TipoAccionRepository _TipoAccionRepository;

        public Repositories.TipoAccionRepository TipoAccionRepository
        {
            get { return _TipoAccionRepository ?? (_TipoAccionRepository = new TipoAccionRepository(_entities)); }
        }
        private Repositories.TipoAreasRepository _TipoAreasRepository;

        public Repositories.TipoAreasRepository TipoAreasRepository
        {
            get { return _TipoAreasRepository ?? (_TipoAreasRepository = new TipoAreasRepository(_entities)); }
        }
        private Repositories.TipoConsultorioRepository _TipoConsultorioRepository;

        public Repositories.TipoConsultorioRepository TipoConsultorioRepository
        {
            get { return _TipoConsultorioRepository ?? (_TipoConsultorioRepository = new TipoConsultorioRepository(_entities)); }
        }
        private Repositories.TipoCoutaRepository _TipoCoutaRepository;

        public Repositories.TipoCoutaRepository TipoCoutaRepository
        {
            get { return _TipoCoutaRepository ?? (_TipoCoutaRepository = new TipoCoutaRepository(_entities)); }
        }
        private Repositories.TipoPacienteRepository _TipoPacienteRepository;

        public Repositories.TipoPacienteRepository TipoPacienteRepository
        {
            get { return _TipoPacienteRepository ?? (_TipoPacienteRepository = new TipoPacienteRepository(_entities)); }
        }
        private Repositories.TipoPagoRepository _TipoPagoRepository;

        public Repositories.TipoPagoRepository TipoPagoRepository
        {
            get { return _TipoPagoRepository ?? (_TipoPagoRepository = new TipoPagoRepository(_entities)); }
        }
        private Repositories.TipoTrastornoRepository _TipoTrastornoRepository;

        public Repositories.TipoTrastornoRepository TipoTrastornoRepository
        {
            get { return _TipoTrastornoRepository ?? (_TipoTrastornoRepository = new TipoTrastornoRepository(_entities)); }
        }
        private Repositories.TrabajoActualESRepository _TrabajoActualESRepository;

        public Repositories.TrabajoActualESRepository TrabajoActualESRepository
        {
            get { return _TrabajoActualESRepository ?? (_TrabajoActualESRepository = new TrabajoActualESRepository(_entities)); }
        }
        private Repositories.TurnosRepository _TurnosRepository;

        public Repositories.TurnosRepository TurnosRepository
        {
            get { return _TurnosRepository ?? (_TurnosRepository = new TurnosRepository(_entities)); }
        }
        private Repositories.TutoresRepository _TutoresRepository;

        public Repositories.TutoresRepository TutoresRepository
        {
            get { return _TutoresRepository ?? (_TutoresRepository = new TutoresRepository(_entities)); }
        }
        private Repositories.UsuariosRepository _UsuariosRepository;

        public Repositories.UsuariosRepository UsuariosRepository
        {
            get { return _UsuariosRepository ?? (_UsuariosRepository = new UsuariosRepository(_entities)); }
        }

       
        #endregion


        private readonly IcerpEntities _entities;
        public UnitOfWork()
        {
            _entities = new IcerpEntities();
        }

        #region Eventos Repositories Properties
        public CatColoniaRepository CatColoniaRepository
        {
            get { return _catColoniaRepository ?? (_catColoniaRepository = new CatColoniaRepository(_entities)); }
        }

        #endregion

        public void Save()
        {
            try
            {
                _entities.SaveChanges();
            }
            catch (Exception exception)
            {
                appLogger.Error(" [  System  ] " + " [Model] " + " [UnitOfWork] " + " [Guardar entidades] " + " [Excepcion] " + " [Crear y Guardar Objetos] ", exception);
                throw new Exception("Error al Guardar la Información", exception);
            }
        }
    }
}
