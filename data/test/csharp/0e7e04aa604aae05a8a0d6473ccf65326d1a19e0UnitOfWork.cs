namespace DrBeshoyClinic.DAL.Repositories.Infrastructure
{
    public class UnitOfWork : IUnitOfWork
    {
        #region IUnitOfWork Members

        private ChronicDiseaseRepository _chronicDiseaseRepository;
        private DrugHxRepository _drugHxRepository;
        private EmgNcvRepository _emgNcvRepository;
        private ExaminationChronicDiseaseRepository _examinationChronicDiseaseRepository;
        private ExaminationRepository _examinationRepository;
        private FamilyHxRepository _familyHxRepository;
        private LabTestRepository _labTestRepository;
        private MedicineDetailsRepository _medicineDetailsRepository;
        private MedicineRepository _medicineRepository;
        private OperationRepository _operationRepository;
        private PatientRepository _patientRepository;
        private PhotoRepository _photoRepository;
        private RadiologyRepository _radiologyRepository;
        private SurgicalHxRepository _surgicalHxRepository;
        private TreatmentDescriptionRepository _treatmentDescriptionRepository;
        private TreatmentPeriodRepository _treatmentPeriodRepository;
        private TreatmentRepository _treatmentRepository;
        private DiagnosisRepository _diagnosisRepository;
        private ComplaintRepository _complaintRepository;
        private PostOperativeTreatmentRepository _postOperativeTreatmentRepository;
        private PostOperativeInstructionRepository _postOperativeInstructionRepository;

        #endregion

        #region Repositries Properties

        public ChronicDiseaseRepository ChronicDiseaseRepository
            => _chronicDiseaseRepository ?? (_chronicDiseaseRepository = new ChronicDiseaseRepository());

        public DrugHxRepository DrugHxRepository => _drugHxRepository ?? (_drugHxRepository = new DrugHxRepository());
        public EmgNcvRepository EmgNcvRepository => _emgNcvRepository ?? (_emgNcvRepository = new EmgNcvRepository());

        public ExaminationChronicDiseaseRepository ExaminationChronicDiseaseRepository =>
            _examinationChronicDiseaseRepository ?? (_examinationChronicDiseaseRepository =
                new ExaminationChronicDiseaseRepository());

        public ExaminationRepository ExaminationRepository
            => _examinationRepository ?? (_examinationRepository = new ExaminationRepository());

        public FamilyHxRepository FamilyHxRepository
            => _familyHxRepository ?? (_familyHxRepository = new FamilyHxRepository());

        public LabTestRepository LabTestRepository
            => _labTestRepository ?? (_labTestRepository = new LabTestRepository());

        public MedicineDetailsRepository MedicineDetailsRepository
            => _medicineDetailsRepository ?? (_medicineDetailsRepository = new MedicineDetailsRepository());

        public MedicineRepository MedicineRepository
            => _medicineRepository ?? (_medicineRepository = new MedicineRepository());

        public OperationRepository OperationRepository
            => _operationRepository ?? (_operationRepository = new OperationRepository());

        public PatientRepository PatientRepository
            => _patientRepository ?? (_patientRepository = new PatientRepository());

        public PhotoRepository PhotoRepository => _photoRepository ?? (_photoRepository = new PhotoRepository());

        public RadiologyRepository RadiologyRepository
            => _radiologyRepository ?? (_radiologyRepository = new RadiologyRepository());

        public SurgicalHxRepository SurgicalHxRepository
            => _surgicalHxRepository ?? (_surgicalHxRepository = new SurgicalHxRepository());

        public TreatmentDescriptionRepository TreatmentDescriptionRepository
            => _treatmentDescriptionRepository ?? (_treatmentDescriptionRepository =
                   new TreatmentDescriptionRepository());

        public TreatmentPeriodRepository TreatmentPeriodRepository
            => _treatmentPeriodRepository ?? (_treatmentPeriodRepository = new TreatmentPeriodRepository());

        public TreatmentRepository TreatmentRepository
            => _treatmentRepository ?? (_treatmentRepository = new TreatmentRepository());

        public DiagnosisRepository DiagnosisRepository
            => _diagnosisRepository ?? (_diagnosisRepository = new DiagnosisRepository());

        public ComplaintRepository ComplaintRepository
            => _complaintRepository ?? (_complaintRepository = new ComplaintRepository());

        public PostOperativeTreatmentRepository PostOperativeTreatmentRepository
            => _postOperativeTreatmentRepository ?? (_postOperativeTreatmentRepository =
                   new PostOperativeTreatmentRepository());

        public PostOperativeInstructionRepository PostOperativeInstructionRepository
            => _postOperativeInstructionRepository ?? (_postOperativeInstructionRepository =
                   new PostOperativeInstructionRepository());

        #endregion
    }
}