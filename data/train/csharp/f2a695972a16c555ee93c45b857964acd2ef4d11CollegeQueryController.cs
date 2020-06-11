using System.Collections.Generic;
using System.Web.Http;
using Lte.Parameters.Abstract;
using Lte.Parameters.Entities;

namespace Lte.WebApp.Controllers.Topic
{
    public class QueryCollegeRegionController : ApiController
    {
        private readonly ICollegeRepository _repository;

        public QueryCollegeRegionController(ICollegeRepository repository)
        {
            _repository = repository;
        }

        public CollegeRegion Get(int id)
        {
            return _repository.GetRegion(id);
        }
    }

    public class CollegeQueryController : ApiController
    {
        private readonly ICollegeRepository _repository;

        public CollegeQueryController(ICollegeRepository repository)
        {
            _repository = repository;
        }

        [HttpGet]
        public IHttpActionResult Get(int id)
        {
            CollegeInfo info = _repository.Get(id);
            return info == null ? (IHttpActionResult)BadRequest("College Id Not Found!") : Ok(info);
        }

        [HttpGet]
        public IHttpActionResult Get(string name)
        {
            CollegeInfo info = _repository.FirstOrDefault(x => x.Name == name);
            return info == null ? (IHttpActionResult) BadRequest("College Name Not Found!") : Ok(info);
        }

        [HttpGet]
        public IEnumerable<CollegeInfo> Get()
        {
            return _repository.GetAll();
        }
    }

    public class CollegeENodebController : ApiController
    {
        private readonly IInfrastructureRepository _repository;
        private readonly IENodebRepository _eNodebRepository;

        public CollegeENodebController(IInfrastructureRepository repository, IENodebRepository eNodebRepository)
        {
            _repository = repository;
            _eNodebRepository = eNodebRepository;
        }

        [HttpGet]
        public IEnumerable<string> Get(string collegeName)
        {
            return _repository.QueryCollegeENodebNames(_eNodebRepository, collegeName);
        }
    }

    public class CollegeENodebsController : ApiController
    {
        private readonly IInfrastructureRepository _repository;
        private readonly IENodebRepository _eNodebRepository;
        private readonly IAlarmRepository _alarmRepository;

        public CollegeENodebsController(IInfrastructureRepository repository, IENodebRepository eNodebRepository,
            IAlarmRepository alarmRepository)
        {
            _repository = repository;
            _eNodebRepository = eNodebRepository;
            _alarmRepository = alarmRepository;
        }

        [HttpGet]
        public IEnumerable<ENodebView> Get(string collegeName)
        {
            return _repository.QueryCollegeENodebs(_eNodebRepository, _alarmRepository, collegeName);
        }
    }

    public class CollegeBtssController : ApiController
    {
        private readonly IInfrastructureRepository _repository;
        private readonly IBtsRepository _btsRepository;

        public CollegeBtssController(IInfrastructureRepository repository, IBtsRepository btsRepository)
        {
            _repository = repository;
            _btsRepository = btsRepository;
        }

        [HttpGet]
        public IEnumerable<CdmaBts> Get(string collegeName)
        {
            return _repository.QueryCollegeBtss(_btsRepository, collegeName);
        }
    }

    public class CollegeLteDistributionsController : ApiController
    {
        private readonly IInfrastructureRepository _repository;
        private readonly IIndoorDistributioinRepository _indoorRepository;

        public CollegeLteDistributionsController(IInfrastructureRepository repository,
            IIndoorDistributioinRepository indoorRepository)
        {
            _repository = repository;
            _indoorRepository = indoorRepository;
        }

        [HttpGet]
        public IEnumerable<IndoorDistribution> Get(string collegeName)
        {
            return _repository.QueryCollegeLteDistributions(_indoorRepository, collegeName);
        }
    }

    public class CollegeCdmaDistributionsController : ApiController
    {
        private readonly IInfrastructureRepository _repository;
        private readonly IIndoorDistributioinRepository _indoorRepository;

        public CollegeCdmaDistributionsController(IInfrastructureRepository repository,
            IIndoorDistributioinRepository indoorRepository)
        {
            _repository = repository;
            _indoorRepository = indoorRepository;
        }

        [HttpGet]
        public IEnumerable<IndoorDistribution> Get(string collegeName)
        {
            return _repository.QueryCollegeCdmaDistributions(_indoorRepository, collegeName);
        }
    }
}
