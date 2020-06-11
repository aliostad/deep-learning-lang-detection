using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Sennit.WEB.Models
{
    public class RepositoryGeneric
    {
        public readonly Sennit.Domain.Core.Repository.EntitiesRepository.LoginRepository _LoginRepository =  new Domain.Core.Repository.EntitiesRepository.LoginRepository();
        public readonly Sennit.Domain.Core.Repository.EntitiesRepository.ClienteRepository _ClienteRepository = new Domain.Core.Repository.EntitiesRepository.ClienteRepository();
        public readonly Sennit.Domain.Core.Repository.EntitiesRepository.CuponRepository _CuponRepository = new Domain.Core.Repository.EntitiesRepository.CuponRepository();
    }
}