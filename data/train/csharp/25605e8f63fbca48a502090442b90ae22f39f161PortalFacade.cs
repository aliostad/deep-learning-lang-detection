using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Portal.Controller;

namespace Portal
{
    public class PortalFacade
    {
        #region[Instancia]
        private static PortalFacade mSingleton;
        public static PortalFacade Singleton
        {
            get
            {
                if (mSingleton == null) mSingleton = new PortalFacade();
                return mSingleton;
            }
        }
        #endregion
        #region[Controladores]

        private PortalController mPortalController;
        public PortalController PortalController
        {
            get
            {
                if (mPortalController == null) mPortalController = new PortalController();
                return mPortalController;
            }
        }
        private AutenticacionController mAutenticacionController;
        public AutenticacionController AutenticacionController
        {
            get
            {
                if (mAutenticacionController == null) mAutenticacionController = new AutenticacionController();
                return mAutenticacionController;
            }
        }
        private PaginaController mPaginaController;
        public PaginaController PaginaController
        {
            get
            {
                if (mPaginaController == null) mPaginaController = new PaginaController();
                return mPaginaController;
            }
        }
        private MenuController mMenuController;
        public MenuController MenuController
        {
            get
            {
                if (mMenuController == null) mMenuController = new MenuController();
                return mMenuController;
            }
        }
        private PermisoController mPermisoController;
        public PermisoController PermisoController
        {
            get
            {
                if (mPermisoController == null) mPermisoController = new PermisoController();
                return mPermisoController;
            }
        }
        private PerfilController mPerfilController;
        public PerfilController PerfilController
        {
            get
            {
                if (mPerfilController == null) mPerfilController = new PerfilController();
                return mPerfilController;
            }
        }
        private SistemaController mSistemaController;
        public SistemaController SistemaController
        {
            get
            {
                if (mSistemaController == null) mSistemaController = new SistemaController();
                return mSistemaController;
            }
        }
        private UsuarioController musuarioController;
        public UsuarioController UsuarioController
        {
            get
            {
                if (musuarioController == null) musuarioController = new UsuarioController();
                return musuarioController;
            }
        }

        private PerfilPermisoController mPerfilPermisoController;
        public PerfilPermisoController PerfilPermisoController
        {
            get
            {
                if (mPerfilPermisoController == null) mPerfilPermisoController = new PerfilPermisoController();
                return mPerfilPermisoController;
            }
        }

        private UsuarioPerfilController mUsuarioPerfilController;
        public UsuarioPerfilController UsuarioPerfilController
        {
            get
            {
                if (mUsuarioPerfilController == null) mUsuarioPerfilController = new UsuarioPerfilController();
                return mUsuarioPerfilController;
            }
        }
        private ADMSistemaTipoController mADMSistemaTipoController;
        public ADMSistemaTipoController ADMSistemaTipoController
        {
            get
            {
                if (mADMSistemaTipoController == null) mADMSistemaTipoController = new ADMSistemaTipoController();
                return mADMSistemaTipoController;
            }
        }


        private ADMSistemaAliasController mADMSistemaAliasController;
        public ADMSistemaAliasController ADMSistemaAliasController
        {
            get
            {
                if (mADMSistemaAliasController == null) mADMSistemaAliasController = new ADMSistemaAliasController();
                return mADMSistemaAliasController;
            }
        }

        private ADM_GrupoController mADM_GrupoController;
        public ADM_GrupoController ADM_GrupoController
        {
            get
            {
                if (mADM_GrupoController == null) mADM_GrupoController = new ADM_GrupoController();
                return mADM_GrupoController;
            }
        }

        private ADM_Grupo_PerfilController mADM_Grupo_PerfilController;
        public ADM_Grupo_PerfilController ADM_Grupo_PerfilController
        {
            get
            {
                if (mADM_Grupo_PerfilController == null) mADM_Grupo_PerfilController = new ADM_Grupo_PerfilController();
                return mADM_Grupo_PerfilController;
            }
        }

        private ADM_Tipo_PermisoController mADM_Tipo_PermisoController;
        public ADM_Tipo_PermisoController ADM_Tipo_PermisoController
        {
            get
            {
                if (mADM_Tipo_PermisoController == null) mADM_Tipo_PermisoController = new ADM_Tipo_PermisoController();
                return mADM_Tipo_PermisoController;
            }
        }

        private ADM_Usuario_Permiso_DelegaController mADM_Usuario_Permiso_DelegaController;
        public ADM_Usuario_Permiso_DelegaController ADM_Usuario_Permiso_DelegaController
        {
            get {
                if (mADM_Usuario_Permiso_DelegaController == null) mADM_Usuario_Permiso_DelegaController = new ADM_Usuario_Permiso_DelegaController();
                return mADM_Usuario_Permiso_DelegaController;
            }
        }

        private ADMUsuarioGrupoController mADMUsuarioGrupoController;
        public ADMUsuarioGrupoController ADMUsuarioGrupoController
        {
            get
            {
                if (mADMUsuarioGrupoController == null) mADMUsuarioGrupoController = new ADMUsuarioGrupoController();
                return mADMUsuarioGrupoController;
            }
        }

        #region [MensajeriaUsuario]
        private ADM_MensajeriaController mADM_MensajeriaController;
        public ADM_MensajeriaController ADM_MensajeriaController
        {
            get
            {
                if (mADM_MensajeriaController == null) mADM_MensajeriaController = new ADM_MensajeriaController();
                return mADM_MensajeriaController;
            }
        }

        #endregion
        #endregion

    }
}
