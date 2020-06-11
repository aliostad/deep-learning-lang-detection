using System;
using Sic.Data.Entity;
using Sic.Apollo.Models;
using Sic.Apollo.Models.Pro;
using Sic.Apollo.Models.General;
using Sic.Apollo.Models.Security;
using Sic.Apollo.Models.Repositories;
using Sic.Apollo.Models.Appointment;
using Sic.Apollo.Models.Medical;

namespace Sic.Apollo.Models
{
    public class ContextService : Sic.Data.Entity.DbContextService<Context>, IDisposable        
    {

        public ContextService()
            :base("Context",true)
        {

        }
        private Repository<Contact> contactRepository;
        private SpecializationRepository specializationRepository;
        private Repository<Institution> institutionRepository;
        private Repository<Country> countryRepository;
        private Repository<State> stateRepository;
        private Repository<City> cityRepository;
        private Repository<ContactLocation> contactLocationRepository;
        private Repository<ContactLocationPicture> contactLocationPictureRepository;
        private ProfessionalOfficeRepository professionalOfficeRepository;
        private Repository<ProfessionalSchool> professionalSchoolRepository;
        private Repository<ProfessionalCommunity> professionalCommunityRepository;
        private Repository<ProfessionalExperience> professionalExperienceRepository;
        private Repository<ProfessionalInsuranceInstitutionPlan> professionalInsuranceInstitutionPlanRepository;
        private Repository<InsuranceInstitutionPlan> insuranceInstitutionPlanRepository;
        private Repository<CustomerProfessional> customerProfessionalRepository;

        private Repository<ProfessionalOfficeSchedule> professionalOfficeScheduleRepository;
        private Repository<ProfessionalSpecialization> professionalSpecializationRepository;

        private Repository<ProfessionalTeam> professionalTeamRepository;
        
        private UserRepository userRepository;
        private ProfessionalRepository professionalRepository;
        private CustomerRepository customerRepository;
        private InsuranceInstitutionRepository insuranceInstitutionRepository;
        private AppointmentRepository appointmentRepository;
        private AppointmentTransactionRepository appointmentTransactionRepository;
        private SpecializationAppointmentReasonRepository specializationAppointmentReasonRepository;

        private PatientRepository patientRepository;
        private Repository<ProfessionalPatient> professionalPatientRepository;
        private Repository<PatientInsuranceInstitution> patientInsuranceInstitutionRepository;
        private Repository<MedicalCare> medicalCareRepository;
        private Repository<PatientVitalSign> patientVitalSignRepository;

        private Repository<VitalSign> vitalSignRepository;
        private Repository<MedicalProblem> medicalProblemRepository;
        private Repository<MedicalHistory> medicalHistoryRepository;
        private Repository<ProfessionalVademecum> professionalVademecumRepository;
        private Repository<MedicalCareMedication> medicalCareMedicationRepository;
        private Repository<PhysicalExamination> physicalExaminationRepository;
        private Repository<PatientPhysicalExamination> patientPhysicalExaminationRepository;
        private Repository<PatientFile> patientFileRepository;

        #region Security Repositories

        public UserRepository Users
        {
            get
            {
                if (this.userRepository == null)
                {
                    this.userRepository = new UserRepository(Context);
                }
                return userRepository;
            }
        }

        #endregion

        #region Professional Repositories

        public ProfessionalRepository Professionals
        {
            get
            {
                if (this.professionalRepository == null)
                {
                    this.professionalRepository = new ProfessionalRepository(Context);
                }
                return professionalRepository;
            }
        }

        public ProfessionalOfficeRepository ProfessionalOffices
        {
            get
            {
                if (this.professionalOfficeRepository == null)
                {
                    this.professionalOfficeRepository = new ProfessionalOfficeRepository(Context);
                }
                return professionalOfficeRepository;
            }
        }

        public Repository<ProfessionalSchool> ProfessionalSchools
        {
            get
            {
                if (this.professionalSchoolRepository == null)
                {
                    this.professionalSchoolRepository = new Repository<ProfessionalSchool>(Context);
                }
                return professionalSchoolRepository;
            }
        }

        public Repository<ProfessionalCommunity> ProfessionalCommunities
        {
            get
            {
                if (this.professionalCommunityRepository == null)
                {
                    this.professionalCommunityRepository = new Repository<ProfessionalCommunity>(Context);
                }
                return professionalCommunityRepository;
            }
        }

        public Repository<ProfessionalExperience> ProfessionalExperiences
        {
            get
            {
                if (this.professionalExperienceRepository == null)
                {
                    this.professionalExperienceRepository = new Repository<ProfessionalExperience>(Context);
                }
                return professionalExperienceRepository;
            }
        }

        public Repository<ProfessionalInsuranceInstitutionPlan> ProfessionalInsuranceInstitutionPlans
        {
            get
            {
                if (this.professionalInsuranceInstitutionPlanRepository == null)
                {
                    this.professionalInsuranceInstitutionPlanRepository = new Repository<ProfessionalInsuranceInstitutionPlan>(Context);
                }
                return professionalInsuranceInstitutionPlanRepository;
            }
        }

        public Repository<ProfessionalSpecialization> ProfessionalSpecializations
        {
            get
            {
                if (this.professionalSpecializationRepository == null)
                {
                    this.professionalSpecializationRepository = new Repository<ProfessionalSpecialization>(Context);
                }
                return professionalSpecializationRepository;
            }
        }

        public Repository<ProfessionalOfficeSchedule> ProfessionalOfficeSchedules
        {
            get
            {
                if (this.professionalOfficeScheduleRepository == null)
                {
                    this.professionalOfficeScheduleRepository = new Repository<ProfessionalOfficeSchedule>(Context);
                }
                return professionalOfficeScheduleRepository;
            }
        }        

        public CustomerRepository Customers
        {
            get
            {
                if (this.customerRepository == null)
                {
                    this.customerRepository = new CustomerRepository(Context);
                }
                return customerRepository;
            }
        }

        public Repository<CustomerProfessional> CustomerProfessionals
        {
            get
            {
                if (this.customerProfessionalRepository == null)
                {
                    this.customerProfessionalRepository = new Repository<CustomerProfessional>(Context);
                }
                return customerProfessionalRepository;
            }
        }

        public SpecializationRepository Specializations
        {
            get
            {
                if (this.specializationRepository == null)
                {
                    this.specializationRepository = new SpecializationRepository(Context);
                }
                return specializationRepository;
            }
        }

        public Repository<Institution> Institutions
        {
            get
            {
                if (this.institutionRepository == null)
                {
                    this.institutionRepository = new Repository<Institution>(Context);
                }
                return institutionRepository;
            }
        }

        public InsuranceInstitutionRepository InsuranceInstitutions
        {
            get
            {
                if (this.insuranceInstitutionRepository == null)
                {
                    this.insuranceInstitutionRepository = new InsuranceInstitutionRepository(Context);
                }
                return insuranceInstitutionRepository;
            }
        }

        public Repository<InsuranceInstitutionPlan> InsuranceInstitutionPlans
        {
            get
            {
                if (this.insuranceInstitutionPlanRepository == null)
                {
                    this.insuranceInstitutionPlanRepository = new Repository<InsuranceInstitutionPlan>(Context);
                }
                return insuranceInstitutionPlanRepository;
            }
        }

        public Repository<ProfessionalTeam> ProfessionalTeams
        {
            get
            {
                if (this.professionalTeamRepository == null)
                {
                    this.professionalTeamRepository = new Repository<ProfessionalTeam>(Context);
                }
                return professionalTeamRepository;
            }
        }

        #endregion

        #region General Repositories

        public Repository<ContactLocation> ContactLocations
        {
            get
            {
                if (this.contactLocationRepository == null)
                {
                    this.contactLocationRepository = new Repository<ContactLocation>(Context);
                }
                return contactLocationRepository;
            }
        }

        public Repository<ContactLocationPicture> ContactLocationPictures
        {
            get{
                if (this.contactLocationPictureRepository == null)
                {
                    this.contactLocationPictureRepository = new Repository<ContactLocationPicture>(Context);
                }
                return this.contactLocationPictureRepository;
            }
        }

        public Repository<Contact> Contacts
        {
            get
            {
                if (this.contactRepository == null)
                {
                    this.contactRepository = new Repository<Contact>(Context);
                }
                return contactRepository;
            }
        }
        

        public Repository<Country> Countries
        {
            get
            {
                if (this.countryRepository == null)
                {
                    this.countryRepository = new Repository<Country>(Context);
                }
                return countryRepository;
            }
        }

        public Repository<State> States
        {
            get
            {
                if (this.stateRepository == null)
                {
                    this.stateRepository = new Repository<State>(Context);
                }
                return stateRepository;
            }
        }

        public Repository<City> Cities
        {
            get
            {
                if (this.cityRepository == null)
                {
                    this.cityRepository = new Repository<City>(Context);
                }
                return cityRepository;
            }
        }

        #endregion

        #region Appointment Repositories

        public AppointmentRepository Appointments
        {
            get
            {
                if (appointmentRepository == null)
                    appointmentRepository = new AppointmentRepository(Context);

                return appointmentRepository;
            }
        }

        public AppointmentTransactionRepository AppointmentTransactions
        {
            get
            {
                if (appointmentTransactionRepository == null)
                    appointmentTransactionRepository = new AppointmentTransactionRepository(Context);

                return appointmentTransactionRepository;
            }
        }

        public SpecializationAppointmentReasonRepository SpecializationAppointmentReasons
        {
            get
            {
                if (specializationAppointmentReasonRepository == null)
                    specializationAppointmentReasonRepository = new SpecializationAppointmentReasonRepository(Context);

                return specializationAppointmentReasonRepository;
            }
        }

        #endregion

        #region Patient Repositories

        public PatientRepository Patients
        {
            get
            {
                if (patientRepository == null)
                    patientRepository = new PatientRepository(Context);

                return patientRepository;
            }
        }

        public Repository<ProfessionalPatient> ProfessionalPatients
        {
            get
            {
                if (professionalPatientRepository == null)
                    professionalPatientRepository = new Repository<ProfessionalPatient>(Context);

                return professionalPatientRepository;
            }
        }

        public Repository<PatientInsuranceInstitution> PatientInsuranceInstitutions
        {
            get
            {
                if (patientInsuranceInstitutionRepository == null)
                    patientInsuranceInstitutionRepository = new Repository<PatientInsuranceInstitution>(Context);

                return patientInsuranceInstitutionRepository;
            }
        }

        public Repository<MedicalCare> MedicalCares
        {
            get
            {
                if (medicalCareRepository == null)
                    medicalCareRepository = new Repository<MedicalCare>(Context);

                return medicalCareRepository;
            }
        }

        public Repository<PatientVitalSign> PatientVitalSigns
        {
            get
            {
                if (patientVitalSignRepository == null)
                    patientVitalSignRepository = new Repository<PatientVitalSign>(Context);

                return patientVitalSignRepository;
            }
        }

        public Repository<VitalSign> VitalSigns
        {
            get
            {
                if (vitalSignRepository == null)
                    vitalSignRepository = new Repository<VitalSign>(Context);

                return vitalSignRepository;
            }
        }

        public Repository<PhysicalExamination> PhysicalExaminations
        {
            get
            {
                if (physicalExaminationRepository == null)
                    physicalExaminationRepository = new Repository<PhysicalExamination>(Context);

                return physicalExaminationRepository;
            }
        }

        public Repository<MedicalProblem> MedicalProblems
        {
            get
            {
                if (medicalProblemRepository == null)
                    medicalProblemRepository = new Repository<MedicalProblem>(Context);

                return medicalProblemRepository;
            }
        }

        public Repository<MedicalHistory> MedicalHistories
        {
            get
            {
                if (medicalHistoryRepository == null)
                    medicalHistoryRepository = new Repository<MedicalHistory>(Context);

                return medicalHistoryRepository;
            }
        }

        public Repository<ProfessionalVademecum> ProfessionalVademecums
        {
            get
            {
                if (professionalVademecumRepository == null)
                    professionalVademecumRepository = new Repository<ProfessionalVademecum>(Context);

                return professionalVademecumRepository;
            }
        }

        public Repository<MedicalCareMedication> MedicalCareMedications
        {
            get
            {
                if (medicalCareMedicationRepository == null)
                    medicalCareMedicationRepository = new Repository<MedicalCareMedication>(Context);

                return medicalCareMedicationRepository;
            }
        }

        public Repository<PatientPhysicalExamination> PatientPhysicalExaminations
        {
            get
            {
                if (patientPhysicalExaminationRepository == null)
                    patientPhysicalExaminationRepository = new Repository<PatientPhysicalExamination>(Context);

                return patientPhysicalExaminationRepository;
            }
        }

        public Repository<PatientFile> PatientFiles
        {
            get
            {
                if (patientFileRepository == null)
                    patientFileRepository = new Repository<PatientFile>(Context);
                return patientFileRepository;
            }
        }

        #endregion

        public void Save()
        {
            Context.SaveChanges();
        }

        private bool disposed = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    Context.Dispose();
                }
            }
            this.disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}