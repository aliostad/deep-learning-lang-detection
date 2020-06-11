using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace IndignaFwk.UI.Process
{
    public class UserProcessFactory
    {
        // SINGLETON
        private UserProcessFactory() { }

        private static UserProcessFactory _instance;

        public static UserProcessFactory Instance
        {
            get
            {
                if (_instance == null)
                {
                    _instance = new UserProcessFactory();
                }

                return _instance;
            }
        }

        // ContenidoUserProcess
        private ContenidoUserProcess _contenidoUserProcess;

        public ContenidoUserProcess ContenidoUserProcess
        {
            get
            {
                if (_contenidoUserProcess == null)
                {
                    _contenidoUserProcess = new ContenidoUserProcess();
                }

                return _contenidoUserProcess;
            }
        }

        // ConvocatoriaUserProcess
        private ConvocatoriaUserProcess _convocatoriaUserProcess;

        public ConvocatoriaUserProcess ConvocatoriaUserProcess
        {
            get
            {
                if (_convocatoriaUserProcess == null)
                {
                    _convocatoriaUserProcess = new ConvocatoriaUserProcess();
                }

                return _convocatoriaUserProcess;
            }
        }

        // GrupoUserProcess
        private GrupoUserProcess _grupoUserProcess;

        public GrupoUserProcess GrupoUserProcess
        {
            get
            {
                if (_grupoUserProcess == null)
                {
                    _grupoUserProcess = new GrupoUserProcess();
                }

                return _grupoUserProcess;
            }
        }

        //UsuarioUserProcess
        private UsuarioUserProcess _usuarioUserProcess;

        public UsuarioUserProcess UsuarioUserProcess
        {
            get
            {
                if (_usuarioUserProcess == null)
                {
                    _usuarioUserProcess = new UsuarioUserProcess();
                }

                return _usuarioUserProcess;
            }
        }

        //AdministradorUserProcess
        private AdministradorUserProcess _adminUserProcess;

        public AdministradorUserProcess AdministradorUserProcess
        {
            get
            {
                if (_adminUserProcess == null)
                {
                    _adminUserProcess = new AdministradorUserProcess();
                }

                return _adminUserProcess;
            }
        }

        //SistemaUserProcess
        private SistemaUserProcess _sistemaUserProcess;

        public SistemaUserProcess SistemaUserProcess
        {
            get
            {
                if (_sistemaUserProcess == null)
                {
                    _sistemaUserProcess = new SistemaUserProcess();
                }

                return _sistemaUserProcess;
            }
        }

    }
}
