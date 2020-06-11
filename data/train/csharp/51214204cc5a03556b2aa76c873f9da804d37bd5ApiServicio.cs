using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SVE_Model.API_entidades
{
    public class ApiServicio:ApiUsuario
    {
        private int _idServicioAPI;

        public int IdServicioAPI
        {
            get { return _idServicioAPI; }
            set { _idServicioAPI = value; }
        }
        private string _NameServicioAPI;

        public string NameServicioAPI
        {
            get { return _NameServicioAPI; }
            set { _NameServicioAPI = value; }
        }
        private string _TipoServicioAPI;

        public string TipoServicioAPI
        {
            get { return _TipoServicioAPI; }
            set { _TipoServicioAPI = value; }
        }
        private string _descripcionServicioAPI;

        public string DescripcionServicioAPI
        {
            get { return _descripcionServicioAPI; }
            set { _descripcionServicioAPI = value; }
        }
         
        

        private int _EstadoServicioAPI;

        public int EstadoServicioAPI
        {
            get { return _EstadoServicioAPI; }
            set { _EstadoServicioAPI = value; }
        }
        private DateTime _FechaInscripcionAPI;

        public DateTime FechaInscripcionAPI
        {
            get { return _FechaInscripcionAPI; }
            set { _FechaInscripcionAPI = value; }
        }
        private DateTime _FechFinAPI;

        public DateTime FechFinAPI
        {
            get { return _FechFinAPI; }
            set { _FechFinAPI = value; }
        }
        public ApiServicio() { }

        public ApiServicio(int idApi, string nombreAPi,string tipoApi,string descripcionApi, int estadoAPi,DateTime fechaCreacion, DateTime fechaInactivacion)  {
            this.IdServicioAPI = idApi;
            this.NameServicioAPI = nombreAPi;
            this.TipoServicioAPI = tipoApi;
            this.DescripcionServicioAPI = descripcionApi;
            this.EstadoServicioAPI = estadoAPi;
            this.FechaInscripcionAPI = fechaCreacion;
            this.FechFinAPI = fechaInactivacion;
            
        }

        /*Herencia de contructores*/
        public ApiServicio(int idApi, string nombreAPi, string tipoApi, string descripcionApi, int estadoAPi, DateTime fechaCreacion, DateTime fechaInactivacion,
            int idUsuario, string nameUsuario, string correo, string telefono, int estado, string descripcion, DateTime fechaInscripcion, DateTime fecha_fin)
            : base(idUsuario, nameUsuario, correo, telefono, estado, descripcion, fechaInscripcion, fecha_fin)
        {
            this.IdServicioAPI = idApi;
            this.NameServicioAPI = nombreAPi;
            this.TipoServicioAPI = tipoApi;
            this.DescripcionServicioAPI = descripcionApi;
            this.EstadoServicioAPI = estadoAPi;
            this.FechaInscripcionAPI = fechaCreacion;
            this.FechFinAPI = fechaInactivacion;

        }

    }
}
