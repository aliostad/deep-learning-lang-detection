using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using Lte.Parameters.Abstract;
using Lte.Parameters.Entities;

namespace Lte.WebApp.Controllers.Topic
{
    public class CollegeCellsController : ApiController
    {
        private readonly IInfrastructureRepository _repository;
        private readonly ICellRepository _cellRepository;
        private readonly IENodebRepository _eNodebRepository;

        public CollegeCellsController(IInfrastructureRepository repository, ICellRepository cellRepository,
            IENodebRepository eNodebRepository)
        {
            _repository = repository;
            _cellRepository = cellRepository;
            _eNodebRepository = eNodebRepository;
        }

        [HttpGet]
        public IEnumerable<CellView> Get(string collegeName)
        {
            return
                _repository.QueryCollegeCells(_cellRepository, collegeName)
                    .Select(x => new CellView(x, _eNodebRepository));
        }
    }

    public class CollegeCdmaCellsController : ApiController
    {
        private readonly IInfrastructureRepository _repository;
        private readonly ICdmaCellRepository _cellRepository;

        public CollegeCdmaCellsController(IInfrastructureRepository repository, ICdmaCellRepository cellRepository)
        {
            _repository = repository;
            _cellRepository = cellRepository;
        }

        [HttpGet]
        public IEnumerable<CdmaCell> Get(string collegeName)
        {
            return _repository.QueryCollegeCdmaCells(_cellRepository, collegeName);
        }
    }

}