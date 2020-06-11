using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SVE_Model.API_entidades
{
    public class ApiConfiguracion : ApiServicio
    {
        private int _idConfiguracionAPI;

        public int IdConfiguracionAPI
        {
            get { return _idConfiguracionAPI; }
            set { _idConfiguracionAPI = value; }
        }
        private string _ConfiguracionAPI;

        public string ConfiguracionAPI
        {
            get { return _ConfiguracionAPI; }
            set { _ConfiguracionAPI = value; }
        }
        private string _valorAPI;

        public string ValorAPI
        {
            get { return _valorAPI; }
            set { _valorAPI = value; }
        }
        private int _EstadoAPI;

        public int EstadoAPI
        {
            get { return _EstadoAPI; }
            set { _EstadoAPI = value; }
        }
        private string _descripcionAPI;

        public string DescripcionAPI
        {
            get { return _descripcionAPI; }
            set { _descripcionAPI = value; }
        }

        public ApiConfiguracion() { }

        public ApiConfiguracion(int idConfiguacionAPI,string configuacionAPI,string valorAPI,int estadoAPI,string descripcionAPI) {
            this.IdConfiguracionAPI = idConfiguacionAPI;
            this.ConfiguracionAPI = configuacionAPI;
            this.ValorAPI = valorAPI;
            this.EstadoAPI = estadoAPI;
            this.DescripcionAPI = descripcionAPI;
        }
    }
}
