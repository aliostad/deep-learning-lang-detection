using Rp3.Data.DbConnection;
using Rp3.Data.Entity;
using Rp3.AgendaComercial.Models.General;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Rp3.AgendaComercial.Models.Ruta;
using Rp3.AgendaComercial.Models.Repositories;
using Rp3.AgendaComercial.Models.General.View;
using Rp3.AgendaComercial.Models.Oportunidad;
using Rp3.AgendaComercial.Models.Marcacion;
using Rp3.AgendaComercial.Models.Pedido;

namespace Rp3.AgendaComercial.Models
{
    public class ContextService : DbContextManagerService<Context>
    {
        public ContextService()
            : base("Context", true)
        {                     
        }

        private Repository<Frecuencia> frecuenciaRepository;
        private Repository<Cargo> cargoRepository;
        private CanalRepository canalRepository;
        private Repository<Region> regionRepository;
        private TipoClienteRepository tipoClienteRepository;
        private Repository<TipoCartera> tipoCarteraRepository;

        private Repository<TipoActividad> tipoActividadRepository;
        private Repository<TipoActividadOpcion> tipoActividadOpcionRepository;

        private ZonaRepository zonaRepository;
        private Repository<ZonaDetalle> zonaDetalleRepository;
        private Repository<ZonaGeocerca> zonaGeocercaRepository;
        private Repository<ZonaClienteGeocerca> zonaClienteGeocercaRepository;
        
        private AgenteRepository agenteRepository;
        private AgenteUbicacionRepository agenteUbicacionRepository;
        private Repository<AgenteUltimaUbicacion> agenteUltimaUbicacionRepository;
        private Repository<InformeTrazabilidad> informeTrazabilidadRepository;

        private ClienteRepository clienteRepository;
        private Repository<ClienteDato> clienteDatoRepository;
        private Repository<ClienteDireccion> clienteDireccionRepository;
        private Repository<ClienteContacto> clienteContactoRepository;
        private Repository<ClienteView> clienteviewRepository;

        private Repository<TareaResumenView> tarearesumenviewRepository;

        private LoteRepository loteRepository;
        private Repository<LoteDetalle> loteDetalleRepository;
        private Repository<LoteTipoCliente> loteTipoClienteRepository;
        private Repository<LoteCanal> loteCanalRepository;
        private Repository<LoteZona> loteZonaRepository;
        
        private RutaRepository rutaRepository;
        private Repository<RutaDetalle> rutaDetalleRepository;
        private Repository<RutaIncluir> rutaIncluirRepository;
        private Repository<RutaExcluir> rutaExcluirRepository;
        private Repository<RutaLote> rutaLoteRepository;

        private TareaRepository tareaDetalleRepository;
                
        private Repository<Reunion> reunionRepository;
        private Repository<ReunionAsistente> reunionAsistenteRepository;
        private Repository<Memo> memoRepository;
        private Repository<MemoDestinatario> memoDestinatarioRepository;

        private TareaRepository tareaRepository;
        private Repository<TareaActividad> tareaActividadRepository;

        private Repository<TareaRutaAplica> tareaRutaRepository;

        private Repository<ProgramacionRuta> programacionRutaRepository;
        private Repository<ProgramacionRutaDetalle> programacionRutaDetalleRepository;
        private Repository<ProgramacionRutaTarea> programacionRutaTareaRepository;

        private AgendaRepository agendaRepository;
        private Repository<AgendaMedia> agendaMediaRepository;
        private Repository<AgendaTarea> agendaTareaRepository;
        private Repository<AgendaTareaActividad> agendaTareaActividadRepository;
        private Repository<Calendario> calendarioRepository;
        private Repository<DiaLaboral> diaLaboralRepository;
        private Repository<DiasNoLaborable> diaNoLaborableRepository;

        private Repository<General.Process> processRepository;
        private Repository<ProcessStep> processStepRepository;
        private Repository<ProcessLog> processLogRepository;

        private Repository<TareaClienteActualizacionCampo> tareaClienteActualizacionCampoRepository;
        private Repository<ParametroClienteCampo> parametroClienteCampoRepository;
        private Repository<TareaClienteActualizacion> tareaClienteActualizacionRepository;

        private LoteRepository lotesRepository;
        private ReporteRepository reporteRepository;

        private ParametroRepository parametroRepository;
        private ParametroHelper parametroHelper;


        private EtapaRepository etapaRepository;
        private Repository<EtapaTarea> etapaTareaRepository;
        private OportunidadRepository oportunidadRepository;
        private Repository<OportunidadContacto> oportunidadContactoRepository;
        private Repository<OportunidadMedia> oportunidadMeidaRepository;
        private Repository<OportunidadResponsable> oportunidadResponsableRepository;
        private Repository<OportunidadEtapa> oportunidadEtapaRepository;
        private Repository<OportunidadTarea> oportunidadTareaRepository;
        private Repository<OportunidadTareaActividad> oportunidadTareaActividadRepository;
        private Repository<OportunidadBitacora> oportunidadBitacoraRepository;
        private Repository<OportunidadTipo> oportunidadTipoRepository;

        private GrupoRepository grupoRepository;
        private Repository<Marcacion.Marcacion> marcacionRepository;
        private PermisoRepository permisoRepository;

        private Repository<Producto> productosRepository;
        private Repository<Descuento> descuentoRepository;
        private PedidoRepository pedidoRepository;
        private Repository<PedidoDetalle> pedidoDetalleRepository;
        private Repository<Categoria> categoriaRepository;
        private Repository<SubCategoria> subCategoriaRepository;

        public Repository<ProgramacionRutaTarea> ProgramacionRutaTareas
        {
            get
            {
                if (programacionRutaTareaRepository == null)
                    programacionRutaTareaRepository = new Repository<ProgramacionRutaTarea>(Context);
                return programacionRutaTareaRepository;
            }
        }
        public Repository<Categoria> Categorias
        {
            get
            {
                if (categoriaRepository == null)
                    categoriaRepository = new Repository<Categoria>(Context);
                return categoriaRepository;
            }
        }
        public Repository<SubCategoria> SubCategorias
        {
            get
            {
                if (subCategoriaRepository == null)
                    subCategoriaRepository = new Repository<SubCategoria>(Context);
                return subCategoriaRepository;
            }
        }
        public Repository<PedidoDetalle> PedidoDetalles
        {
            get
            {
                if (pedidoDetalleRepository == null)
                    pedidoDetalleRepository = new Repository<PedidoDetalle>(Context);
                return pedidoDetalleRepository;
            }
        }
        public PedidoRepository Pedidos
        {
            get
            {
                if (pedidoRepository == null)
                    pedidoRepository = new PedidoRepository(Context);
                return pedidoRepository;
            }
        }
        public Repository<Descuento> Descuentos
        {
            get
            {
                if (descuentoRepository == null)
                    descuentoRepository = new Repository<Descuento>(Context);
                return descuentoRepository;
            }
        }

        public Repository<Producto> Productos
        {
            get
            {
                if (productosRepository == null)
                    productosRepository = new Repository<Producto>(Context);
                return productosRepository;
            }
        }

        public Repository<InformeTrazabilidad> InformeTrazabilidads
        {
            get
            {
                if (informeTrazabilidadRepository == null)
                    informeTrazabilidadRepository = new Repository<InformeTrazabilidad>(Context);
                return informeTrazabilidadRepository;
            }
        }

        public Repository<OportunidadBitacora> OportunidadBitacoras
        {
            get
            {
                if (oportunidadBitacoraRepository == null)
                    oportunidadBitacoraRepository = new Repository<OportunidadBitacora>(Context);
                return oportunidadBitacoraRepository;
            }
        }

        public Repository<OportunidadTipo> OportunidadTipos
        {
            get
            {
                if (oportunidadTipoRepository == null)
                    oportunidadTipoRepository = new Repository<OportunidadTipo>(Context);
                return oportunidadTipoRepository;
            }
        }

        public Repository<AgenteUltimaUbicacion> AgenteUltimaUbicacions
        {
            get
            {
                if (agenteUltimaUbicacionRepository == null)
                    agenteUltimaUbicacionRepository = new Repository<AgenteUltimaUbicacion>(Context);
                return agenteUltimaUbicacionRepository;
            }
        }

        public GrupoRepository Grupos
        {
            get
            {
                if (grupoRepository == null)
                    grupoRepository = new GrupoRepository(Context);
                return grupoRepository;
            }
        }

        public Repository<Marcacion.Marcacion> Marcacions
        {
            get
            {
                if (marcacionRepository == null)
                    marcacionRepository = new Repository<Marcacion.Marcacion>(Context);
                return marcacionRepository;
            }
        }

        public PermisoRepository Permisos
        {
            get
            {
                if (permisoRepository == null)
                    permisoRepository = new PermisoRepository(Context);
                return permisoRepository;
            }
        }

        public EtapaRepository Etapas
        {
            get
            {
                if (etapaRepository == null)
                    etapaRepository = new EtapaRepository(Context);
                return etapaRepository;
            }
        }

        public Repository<EtapaTarea> EtapaTareas
        {
            get
            {
                if (etapaTareaRepository == null)
                    etapaTareaRepository = new Repository<EtapaTarea>(Context);
                return etapaTareaRepository;
            }
        }

        public OportunidadRepository Oportunidades
        {
            get
            {
                if (oportunidadRepository == null)
                    oportunidadRepository = new OportunidadRepository(Context);
                return oportunidadRepository;
            }
        }

        public Repository<OportunidadContacto> OportunidadContactos
        {
            get
            {
                if (oportunidadContactoRepository == null)
                    oportunidadContactoRepository = new Repository<OportunidadContacto>(Context);
                return oportunidadContactoRepository;
            }
        }

        public Repository<OportunidadMedia> OportunidadMedias
        {
            get
            {
                if (oportunidadMeidaRepository == null)
                    oportunidadMeidaRepository = new Repository<OportunidadMedia>(Context);
                return oportunidadMeidaRepository;
            }
        }

        public Repository<OportunidadResponsable> OportunidadResponsables
        {
            get
            {
                if (oportunidadResponsableRepository == null)
                    oportunidadResponsableRepository = new Repository<OportunidadResponsable>(Context);
                return oportunidadResponsableRepository;
            }
        }

        public Repository<OportunidadEtapa> OportunidadEtapas
        {
            get
            {
                if (oportunidadEtapaRepository == null)
                    oportunidadEtapaRepository = new Repository<OportunidadEtapa>(Context);
                return oportunidadEtapaRepository;
            }
        }

        public Repository<OportunidadTarea> OportunidadTareas
        {
            get
            {
                if (oportunidadTareaRepository == null)
                    oportunidadTareaRepository = new Repository<OportunidadTarea>(Context);
                return oportunidadTareaRepository;
            }
        }

        public Repository<OportunidadTareaActividad> OportunidadTareaActividads
        {
            get
            {
                if (oportunidadTareaActividadRepository == null)
                    oportunidadTareaActividadRepository = new Repository<OportunidadTareaActividad>(Context);
                return oportunidadTareaActividadRepository;
            }
        }

        public ParametroHelper ParametroHelper
        {
            get
            {
                if (parametroHelper == null)
                    parametroHelper = new ParametroHelper(Context);
                return parametroHelper;
            }
        }

        public ReporteRepository Reporte
        {
            get
            {
                if (reporteRepository == null)
                    reporteRepository = new ReporteRepository(Context);
                return reporteRepository;
            }
        }

        public ParametroRepository Parametros
        {
            get
            {
                if (parametroRepository == null)
                    parametroRepository = new ParametroRepository(Context);
                return parametroRepository;
            }
        }

        public Repository<AgendaTareaActividad> AgendaTareaActividades
        {
            get
            {
                if (agendaTareaActividadRepository == null)
                    agendaTareaActividadRepository = new Repository<AgendaTareaActividad>(Context);
                return agendaTareaActividadRepository;
            }
        }

        public Repository<AgendaTarea> AgendaTareas
        {
            get
            {
                if (agendaTareaRepository == null)
                    agendaTareaRepository = new Repository<AgendaTarea>(Context);
                return agendaTareaRepository;
            }
        }

        public AgendaRepository Agendas
        {
            get
            {
                if (agendaRepository == null)
                    agendaRepository = new AgendaRepository(Context);
                return agendaRepository;
            }
        }
        public Repository<AgendaMedia> AgendaMedias
        {
            get
            {
                if (agendaMediaRepository == null)
                    agendaMediaRepository = new Repository<AgendaMedia>(Context);
                return agendaMediaRepository;
            }
        }
        public LoteRepository Lote
        {
            get
            {
                if (lotesRepository == null)
                    lotesRepository = new LoteRepository(Context);
                return lotesRepository;
            }
        }
        public Repository<ProgramacionRutaDetalle> ProgramacionRutaDetalles
        {
            get
            {
                if (programacionRutaDetalleRepository == null)
                    programacionRutaDetalleRepository = new Repository<ProgramacionRutaDetalle>(Context);
                return programacionRutaDetalleRepository;
            }
        }

        public Repository<ProgramacionRuta> ProgramacionRutas
        {
            get
            {
                if (programacionRutaRepository == null)
                    programacionRutaRepository = new Repository<ProgramacionRuta>(Context);
                return programacionRutaRepository;
            }
        }

        public Repository<Calendario> Calendarios
        {
            get
            {
                if (calendarioRepository == null)
                    calendarioRepository = new Repository<Calendario>(Context);
                return calendarioRepository;
            }
        }

        public Repository<DiaLaboral> DiasLaborales
        {
            get
            {
                if (diaLaboralRepository == null)
                    diaLaboralRepository = new Repository<DiaLaboral>(Context);
                return diaLaboralRepository;
            }
        }

        public Repository<DiasNoLaborable> DiasNoLaborables
        {
            get
            {
                if (diaNoLaborableRepository == null)
                    diaNoLaborableRepository = new Repository<DiasNoLaborable>(Context);
                return diaNoLaborableRepository;
            }
        }


        public Repository<TipoActividadOpcion> TipoActividadOpciones
        {
            get
            {
                if (tipoActividadOpcionRepository == null)
                    tipoActividadOpcionRepository = new Repository<TipoActividadOpcion>(Context);
                return tipoActividadOpcionRepository;
            }
        }

        public Repository<TipoActividad> TipoActividades
        {
            get
            {
                if (tipoActividadRepository == null)
                    tipoActividadRepository = new Repository<TipoActividad>(Context);
                return tipoActividadRepository;
            }
        }       

        public Repository<TareaRutaAplica> TareaRutaAplicas
        {
            get
            {
                if (tareaRutaRepository == null)
                    tareaRutaRepository = new Repository<TareaRutaAplica>(Context);
                return tareaRutaRepository;
            }
        }

        public Repository<TareaActividad> TareaActividades
        {
            get
            {
                if (tareaActividadRepository == null)
                    tareaActividadRepository = new Repository<TareaActividad>(Context);
                return tareaActividadRepository;
            }
        }

        public TareaRepository Tareas
        {
            get
            {
                if (tareaRepository == null)
                    tareaRepository = new TareaRepository(Context);
                return tareaRepository;
            }
        }

        public Repository<MemoDestinatario> MemoDestinatarios
        {
            get
            {
                if (memoDestinatarioRepository == null)
                    memoDestinatarioRepository = new Repository<MemoDestinatario>(Context);
                return memoDestinatarioRepository;
            }
        }

        public Repository<Memo> Memos
        {
            get
            {
                if (memoRepository == null)
                    memoRepository = new Repository<Memo>(Context);
                return memoRepository;
            }
        }

        public Repository<ReunionAsistente> ReunionAsistentes
        {
            get
            {
                if (reunionAsistenteRepository == null)
                    reunionAsistenteRepository = new Repository<ReunionAsistente>(Context);
                return reunionAsistenteRepository;
            }
        }

        public Repository<Reunion> Reuniones
        {
            get
            {
                if (reunionRepository == null)
                    reunionRepository = new Repository<Reunion>(Context);
                return reunionRepository;
            }
        }

        public AgenteUbicacionRepository AgenteUbicaciones
        {
            get
            {
                if (agenteUbicacionRepository == null)
                    agenteUbicacionRepository = new AgenteUbicacionRepository(Context);
                return agenteUbicacionRepository;
            }
        }

        public Repository<RutaLote> RutaLotes
        {
            get
            {
                if (rutaLoteRepository == null)
                    rutaLoteRepository = new Repository<RutaLote>(Context);
                return rutaLoteRepository;
            }
        }

        public Repository<RutaIncluir> RutaIncluirs
        {
            get
            {
                if (rutaIncluirRepository == null)
                    rutaIncluirRepository = new Repository<RutaIncluir>(Context);
                return rutaIncluirRepository;
            }
        }


        public Repository<RutaExcluir> RutaExcluirs
        {
            get
            {
                if (rutaExcluirRepository == null)
                    rutaExcluirRepository = new Repository<RutaExcluir>(Context);
                return rutaExcluirRepository;
            }
        }


        public Repository<RutaDetalle> RutaDetalles
        {
            get
            {
                if (rutaDetalleRepository == null)
                    rutaDetalleRepository = new Repository<RutaDetalle>(Context);
                return rutaDetalleRepository;
            }
        }

        public RutaRepository Rutas
        {
            get
            {
                if (rutaRepository == null)
                    rutaRepository = new RutaRepository(Context);
                return rutaRepository;
            }
        }

        public TareaRepository TareasDetalle
        {
            get
            {
                if (tareaDetalleRepository == null)
                    tareaDetalleRepository = new TareaRepository(Context);
                return tareaDetalleRepository;
            }
        }
        /*public Repository<Tarea> Tareas
        {
            get
            {
                if (tareaRepository == null)
                    tareaRepository = new Repository<Tarea>(Context);
                return tareaRepository;
            }
        }*/
        public Repository<LoteZona> LoteZonas
        {
            get
            {
                if (loteZonaRepository == null)
                    loteZonaRepository = new Repository<LoteZona>(Context);
                return loteZonaRepository;
            }
        }

        public Repository<LoteCanal> LoteCanales
        {
            get
            {
                if (loteCanalRepository == null)
                    loteCanalRepository = new Repository<LoteCanal>(Context);
                return loteCanalRepository;
            }
        }

        public Repository<LoteTipoCliente> LoteTipoClientes
        {
            get
            {
                if (loteTipoClienteRepository == null)
                    loteTipoClienteRepository = new Repository<LoteTipoCliente>(Context);
                return loteTipoClienteRepository;
            }
        }

        public Repository<LoteDetalle> LoteDetalles
        {
            get
            {
                if (loteDetalleRepository == null)
                    loteDetalleRepository = new Repository<LoteDetalle>(Context);
                return loteDetalleRepository;
            }
        }

        public LoteRepository Lotes
        {
            get
            {
                if (loteRepository == null)
                    loteRepository = new LoteRepository(Context);
                return loteRepository;
            }
        }

        public ClienteRepository Clientes
        {
            get
            {
                if (clienteRepository == null)
                    clienteRepository = new ClienteRepository(Context);
                return clienteRepository;
            }
        }

        public Repository<ClienteDato> ClienteDatos
        {
            get
            {
                if (clienteDatoRepository == null)
                    clienteDatoRepository = new Repository<ClienteDato>(Context);
                return clienteDatoRepository;
            }
        }

        public Repository<ClienteDireccion> ClienteDirecciones
        {
            get
            {
                if (clienteDireccionRepository == null)
                    clienteDireccionRepository = new Repository<ClienteDireccion>(Context);
                return clienteDireccionRepository;
            }
        }

        public Repository<ClienteContacto> ClienteContactos
        {
            get
            {
                if (clienteContactoRepository == null)
                    clienteContactoRepository = new Repository<ClienteContacto>(Context);
                return clienteContactoRepository;
            }
        }

        public Repository<ClienteView> ClienteViews
        {
            get
            {
                if (clienteviewRepository == null)
                    clienteviewRepository = new Repository<ClienteView>(Context);
                return clienteviewRepository;
            }
        }

        public Repository<TareaResumenView> TareaResumenViews
        {
            get
            {
                if (tarearesumenviewRepository== null)
                    tarearesumenviewRepository = new Repository<TareaResumenView>(Context);
                return tarearesumenviewRepository;
            }
        }

        public Repository<Cargo> Cargos
        {
            get
            {
                if (cargoRepository == null)
                    cargoRepository = new Repository<Cargo>(Context);
                return cargoRepository;
            }
        }
        public CanalRepository Canales
        {
            get
            {
                if (canalRepository == null)
                    canalRepository = new CanalRepository(Context);
                return canalRepository;
            }
        }
        public Repository<Region> Regiones
        {
            get
            {
                if (regionRepository == null)
                    regionRepository = new Repository<Region>(Context);
                return regionRepository;
            }
        }
        public TipoClienteRepository TipoClientes
        {
            get
            {
                if (tipoClienteRepository == null)
                    tipoClienteRepository = new TipoClienteRepository(Context);
                return tipoClienteRepository;
            }
        }
        public ZonaRepository Zonas
        {
            get
            {
                if (zonaRepository == null)
                    zonaRepository = new ZonaRepository(Context);
                return zonaRepository;
            }
        }

        public Repository<ZonaDetalle> ZonaDetalles
        {
            get
            {
                if (zonaDetalleRepository == null)
                    zonaDetalleRepository = new Repository<ZonaDetalle>(Context);
                return zonaDetalleRepository;
            }
        }

        public Repository<ZonaClienteGeocerca> ZonaClienteGeocercas
         {
            get
            {
                if (zonaClienteGeocercaRepository == null)
                    zonaClienteGeocercaRepository = new Repository<ZonaClienteGeocerca>(Context);
                return zonaClienteGeocercaRepository;
            }
        }

        public Repository<ZonaGeocerca> ZonaGeocercas
        {
            get
            {
                if (zonaGeocercaRepository == null)
                    zonaGeocercaRepository = new Repository<ZonaGeocerca>(Context);
                return zonaGeocercaRepository;
            }
        }

        public Repository<TipoCartera> TipoCarteras
        {
            get
            {
                if (tipoCarteraRepository == null)
                    tipoCarteraRepository = new Repository<TipoCartera>(Context);
                return tipoCarteraRepository;
            }
        }

        public AgenteRepository Agentes
        {
            get
            {
                if (agenteRepository == null)
                    agenteRepository = new AgenteRepository(Context);
                return agenteRepository;
            }
        }

        public Repository<Frecuencia> Frecuencias
        {
            get
            {
                if (frecuenciaRepository == null)
                    frecuenciaRepository = new Repository<Frecuencia>(Context);
                return frecuenciaRepository;
            }
        }

        public Repository<General.Process> Processes
        {
            get
            {
                if (processRepository == null)
                    processRepository = new Repository<General.Process>(Context);
                return processRepository;
            }
        }
        public Repository<ProcessStep> ProcessSteps
        {
            get
            {
                if (processStepRepository == null)
                    processStepRepository = new Repository<ProcessStep>(Context);
                return processStepRepository;
            }
        }
        public Repository<ProcessLog> ProcessLogs
        {
            get
            {
                if (processLogRepository == null)
                    processLogRepository = new Repository<ProcessLog>(Context);
                return processLogRepository;
            }
        }

        public Repository<TareaClienteActualizacionCampo> TareaClienteActualizacionCampos
        {
            get
            {
                if (tareaClienteActualizacionCampoRepository == null)
                    tareaClienteActualizacionCampoRepository = new Repository<TareaClienteActualizacionCampo>(Context);
                return tareaClienteActualizacionCampoRepository;
            }
        }

        public Repository<ParametroClienteCampo> ParametroClienteCampos
        {
            get
            {
                if (parametroClienteCampoRepository == null)
                    parametroClienteCampoRepository = new Repository<ParametroClienteCampo>(Context);
                return parametroClienteCampoRepository;
            }
        }

        public Repository<TareaClienteActualizacion> TareaClienteActualizaciones
        {
            get
            {
                if (tareaClienteActualizacionRepository == null)
                    tareaClienteActualizacionRepository = new Repository<TareaClienteActualizacion>(Context);
                return tareaClienteActualizacionRepository;
            }
        }
    }
}
