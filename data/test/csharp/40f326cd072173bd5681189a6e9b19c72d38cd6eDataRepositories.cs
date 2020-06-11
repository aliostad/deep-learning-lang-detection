

using EPTS.Repositories.WebServices.WebAPI.Infrastructure.Entities.Testing;

namespace EPTS.Repositories.WebServices.WebAPI.Repositories
{
    public class DataRepositories : IDataRepositories
    {



        public DataRepositories(BusinessUnitRepository businessUnitRepository, FamilyRepository familyRepository, FlowRepository flowRepository, LineRepository lineRepository, ModelRepository modelRepository, ModelDetailRepository modelDetailRepository, PartNumberRepository partNumberRepository, StationRepository stationRepository, TestGroupRepository testGroupRepository,  TestRepository testRepository, TestPlanRepository testPlanRepository, TestTypeRepository testTypeRepository, TestUnitRepository testUnitRepository, TestResultRepository testResultRepository,StationGroupRepository stationGroupRepository)
        {
            BusinessUnitRepository = businessUnitRepository;
            FamilyRepository = familyRepository;
            FlowRepository = flowRepository;
            LineRepository = lineRepository;
            ModelRepository = modelRepository;
            ModelDetailRepository = modelDetailRepository;
            PartNumberRepository = partNumberRepository;
            StationRepository = stationRepository;
            TestGroupRepository = testGroupRepository;
            TestRepository = testRepository;
            TestPlanRepository = testPlanRepository;
            TestTypeRepository = testTypeRepository;
            TestUnitRepository = testUnitRepository;
            TestResultRepository = testResultRepository;
            StationGroupRepository = stationGroupRepository;
        }

        public BusinessUnitRepository BusinessUnitRepository { get; set; }
        public FamilyRepository FamilyRepository { get; set; }
        public FlowRepository FlowRepository { get; set; }
        public LineRepository LineRepository { get; set; }
        public ModelRepository ModelRepository { get; set; }
        public ModelDetailRepository ModelDetailRepository { get; set; }
        public PartNumberRepository PartNumberRepository { get; set; }
        public StationRepository StationRepository { get; set; }
        public TestGroupRepository TestGroupRepository { get; set; }
        public TestPlanRepository TestPlanRepository { get; set; }
        public TestRepository TestRepository { get; set; }
        public TestTypeRepository TestTypeRepository { get; set; }
        public TestUnitRepository TestUnitRepository { get; set; }
        public TestResultRepository TestResultRepository { get; set; }
        public StationGroupRepository StationGroupRepository { get; set; }
    }

    public interface IDataRepositories
    {
        BusinessUnitRepository BusinessUnitRepository { get; set; }
        FamilyRepository FamilyRepository { get; set; }
        FlowRepository FlowRepository { get; set; }
        LineRepository LineRepository { get; set; }
        ModelRepository ModelRepository { get; set; }
        ModelDetailRepository ModelDetailRepository { get; set; }
        PartNumberRepository PartNumberRepository { get; set; }
        StationRepository StationRepository { get; set; }
        TestGroupRepository TestGroupRepository { get; set; }
        TestPlanRepository TestPlanRepository { get; set; }
        TestRepository TestRepository { get; set; }
        TestTypeRepository TestTypeRepository { get; set; }
        TestUnitRepository TestUnitRepository { get; set; }
        TestResultRepository TestResultRepository { get; set; }
        StationGroupRepository StationGroupRepository { get; set; }

    }
}