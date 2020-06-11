using ShopNC.IRepository;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace ShopNC.Repository
{
    public partial class DBSession:IDBSession
    {

        private IUserInfoRepository _UserInfoRepository;
        public  IUserInfoRepository  UserInfoRepository
        {
            get 
            {
                if (_UserInfoRepository == null)
                {
                   _UserInfoRepository=new UserInfoRepository();
                }

                return _UserInfoRepository;
            }
        }


        private IUserRoleRepository _UserRoleRepository;
        public  IUserRoleRepository  UserRoleRepository
        {
            get 
            {
                if (_UserRoleRepository == null)
                {
                   _UserRoleRepository=new UserRoleRepository();
                }

                return _UserRoleRepository;
            }
        }


        private IPermissionRepository _PermissionRepository;
        public  IPermissionRepository  PermissionRepository
        {
            get 
            {
                if (_PermissionRepository == null)
                {
                   _PermissionRepository=new PermissionRepository();
                }

                return _PermissionRepository;
            }
        }


        private IPermissionGroupRepository _PermissionGroupRepository;
        public  IPermissionGroupRepository  PermissionGroupRepository
        {
            get 
            {
                if (_PermissionGroupRepository == null)
                {
                   _PermissionGroupRepository=new PermissionGroupRepository();
                }

                return _PermissionGroupRepository;
            }
        }

    }
}

