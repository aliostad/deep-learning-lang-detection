namespace DrBeshoyClinic.DAL.Repositories.Infrastructure
{
    public interface IUnitOfWork
    {
        ChronicDiseaseRepository ChronicDiseaseRepository { get; }
        DrugHxRepository DrugHxRepository { get; }
        EmgNcvRepository EmgNcvRepository { get; }
        ExaminationChronicDiseaseRepository ExaminationChronicDiseaseRepository { get; }
        ExaminationRepository ExaminationRepository { get; }
        FamilyHxRepository FamilyHxRepository { get; }
        LabTestRepository LabTestRepository { get; }
        MedicineDetailsRepository MedicineDetailsRepository { get; }
        MedicineRepository MedicineRepository { get; }
        OperationRepository OperationRepository { get; }
        PatientRepository PatientRepository { get; }
        PhotoRepository PhotoRepository { get; }
        RadiologyRepository RadiologyRepository { get; }
        SurgicalHxRepository SurgicalHxRepository { get; }
        TreatmentDescriptionRepository TreatmentDescriptionRepository { get; }
        TreatmentPeriodRepository TreatmentPeriodRepository { get; }
        TreatmentRepository TreatmentRepository { get; }
        DiagnosisRepository DiagnosisRepository { get; }
        ComplaintRepository ComplaintRepository { get; }
        PostOperativeTreatmentRepository PostOperativeTreatmentRepository { get; }
        PostOperativeInstructionRepository PostOperativeInstructionRepository { get; }
    }
}