using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GeoPgesSystem.Db.IRepositories;

namespace GeoPgesSystem.Db.Context
{
    public class UnitWork : IUnitWork
    {
        public IAuthRepository AuthRepository { get; set; }
        public ICablePointsRepository CablePointsRepository { get; set; }
        public ICablesRepository CablesRepository { get; set; }
        public IDefectPicsRepository DefectPicsRepository { get; set; }
        public IDocumentsRepository DocumentsRepository { get; set; }
        public IElektroCellRepository ElektroCellRepository { get; set; }
        public IFileTypeRepository FileTypeRepository { get; set; }
        public IKachestvoFileRepository KachestvoFileRepository { get; set; }
        public IRepairsRepository RepairsRepository { get; set; }
        public IRubilniksRepository RubilniksRepository { get; set; }
        public ITPRepository TpRepository { get; set; }
        public IUserProfileRepository UserProfileRepository { get; set; }
        public IVedomostRepository VedomostRepository { get; set; }
        public IVlRepository VlRepository { get; set; }
        public IWialonRepository WialonRepository { get; set; }

        public UnitWork(
            IAuthRepository authRepository,
            ICablePointsRepository cablePointsRepository,
            ICablesRepository cablesRepository,
            IDefectPicsRepository defectPicsRepository,
            IDocumentsRepository documentsRepository,
            IElektroCellRepository elektroCellRepository,
            IFileTypeRepository fileTypeRepository,
            IKachestvoFileRepository kachestvoFileRepository,
            IRepairsRepository repairsRepository,
            IRubilniksRepository rubilniksRepository,
            ITPRepository tpRepository,
            IUserProfileRepository userProfileRepository,
            IVedomostRepository vedomostRepository,
            IVlRepository vlRepository,
            IWialonRepository wialonRepository
            )
        {
            AuthRepository = authRepository;
            CablePointsRepository = cablePointsRepository;
            CablesRepository = cablesRepository;
            DefectPicsRepository = defectPicsRepository;
            DocumentsRepository = documentsRepository;
            ElektroCellRepository = elektroCellRepository;
            FileTypeRepository = fileTypeRepository;
            KachestvoFileRepository = kachestvoFileRepository;
            RepairsRepository = repairsRepository;
            RubilniksRepository = rubilniksRepository;
            TpRepository = tpRepository;
            UserProfileRepository = userProfileRepository;
            VedomostRepository = vedomostRepository;
            VlRepository = vlRepository;
            WialonRepository = wialonRepository;
        }
    }
}
