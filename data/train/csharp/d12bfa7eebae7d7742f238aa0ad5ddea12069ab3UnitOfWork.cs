using System;
using JobSearchingSystem.Models;

namespace JobSearchingSystem.DAL
{
    public class UnitOfWork : IDisposable
    {
        private JSSContext context = new JSSContext();

        /**
         * Single Table Repository
         */
        private GenericRepository<Administrator> administratorRepository;
        private GenericRepository<Advertise> advertiseRepository;
        private GenericRepository<AppliedJob> appliedJobRepository;
        private GenericRepository<AspNetRole> aspNetRoleRepository;
        private GenericRepository<AspNetUser> aspNetUserRepository;
        private GenericRepository<AspNetUserClaim> aspNetUserClaimRepository;
        private GenericRepository<AspNetUserLogin> aspNetUserLoginRepository;
        private GenericRepository<Benefit> benefitRepository;
        private GenericRepository<Category> categoryRepository;
        private GenericRepository<City> cityRepository;
        private GenericRepository<CompanyInfo> companyInfoRepository;
        private GenericRepository<CompanyInfoCity> companyInfoCityRepository;
        private GenericRepository<Contact> contactRepository;
        private GenericRepository<DesiredBenefit> desiredBenefitRepository;
        private GenericRepository<EducationHistory> educationHistoryRepository;
        private GenericRepository<EmploymentHistory> employmentHistoryRepository;
        private GenericRepository<ExpectedCategory> expectedCategoryRepository;
        private GenericRepository<ExpectedCity> expectedCityRepository;
        private GenericRepository<Job> jobRepository;
        private GenericRepository<JobBenefit> jobBenefitRepository;
        private GenericRepository<JobCategory> jobCategoryRepository;
        private GenericRepository<JobCity> jobCityRepository;
        private GenericRepository<JobLanguage> jobLanguageRepository;
        private GenericRepository<JobLevel> jobLevelRepository;
        private GenericRepository<JobPackage> jobPackageRepository;
        private GenericRepository<Jobseeker> jobseekerRepository;
        private GenericRepository<JobSkill> jobSkillRepository;
        private GenericRepository<Language> languageRepository;
        private GenericRepository<Level> levelRepository;
        private GenericRepository<Manager> managerRepository;
        private GenericRepository<Message> messageRepository;
        private GenericRepository<MessageReceiver> messageReceiverRepository;
        private GenericRepository<OwnSkill> ownSkillRepository;
        private GenericRepository<Profile> profileRepository;
        private GenericRepository<PurchaseAdvertise> purchaseAdvertiseRepository;
        private GenericRepository<PurchaseJobPackage> purchaseJobPackageRepository;
        private GenericRepository<Recruiter> recruiterRepository;
        private GenericRepository<ReferencePerson> referencePersonRepository;
        private GenericRepository<Report> reportRepository;
        private GenericRepository<SchoolLevel> schoolLevelRepository;
        private GenericRepository<Skill> skillRepository;
        private GenericRepository<Staff> staffRepository;
        private GenericRepository<Topic> topicRepository;
        private GenericRepository<ViewProfile> viewProfileRepository;

        public GenericRepository<Administrator> AdministratorRepository
        {
            get
            {
                if (this.administratorRepository == null)
                {
                    this.administratorRepository = new GenericRepository<Administrator>(context);
                }
                return administratorRepository;
            }
        }

        public GenericRepository<Advertise> AdvertiseRepository
        {
            get
            {
                if (this.advertiseRepository == null)
                {
                    this.advertiseRepository = new GenericRepository<Advertise>(context);
                }
                return advertiseRepository;
            }
        }

        public GenericRepository<AppliedJob> AppliedJobRepository
        {
            get
            {
                if (this.appliedJobRepository == null)
                {
                    this.appliedJobRepository = new GenericRepository<AppliedJob>(context);
                }
                return appliedJobRepository;
            }
        }

        public GenericRepository<AspNetRole> AspNetRoleRepository
        {
            get
            {
                if (this.aspNetRoleRepository == null)
                {
                    this.aspNetRoleRepository = new GenericRepository<AspNetRole>(context);
                }
                return aspNetRoleRepository;
            }
        }

        public GenericRepository<AspNetUser> AspNetUserRepository
        {
            get
            {
                if (this.aspNetUserRepository == null)
                {
                    this.aspNetUserRepository = new GenericRepository<AspNetUser>(context);
                }
                return aspNetUserRepository;
            }
        }

        public GenericRepository<AspNetUserClaim> AspNetUserClaimRepository
        {
            get
            {
                if (this.aspNetUserClaimRepository == null)
                {
                    this.aspNetUserClaimRepository = new GenericRepository<AspNetUserClaim>(context);
                }
                return aspNetUserClaimRepository;
            }
        }

        public GenericRepository<AspNetUserLogin> AspNetUserLoginRepository
        {
            get
            {
                if (this.aspNetUserLoginRepository == null)
                {
                    this.aspNetUserLoginRepository = new GenericRepository<AspNetUserLogin>(context);
                }
                return aspNetUserLoginRepository;
            }
        }

        public GenericRepository<Benefit> BenefitRepository
        {
            get
            {
                if (this.benefitRepository == null)
                {
                    this.benefitRepository = new GenericRepository<Benefit>(context);
                }
                return benefitRepository;
            }
        }

        public GenericRepository<Category> CategoryRepository
        {
            get
            {
                if (this.categoryRepository == null)
                {
                    this.categoryRepository = new GenericRepository<Category>(context);
                }
                return categoryRepository;
            }
        }

        public GenericRepository<City> CityRepository
        {
            get
            {
                if (this.cityRepository == null)
                {
                    this.cityRepository = new GenericRepository<City>(context);
                }
                return cityRepository;
            }
        }

        public GenericRepository<CompanyInfo> CompanyInfoRepository
        {
            get
            {
                if (this.companyInfoRepository == null)
                {
                    this.companyInfoRepository = new GenericRepository<CompanyInfo>(context);
                }
                return companyInfoRepository;
            }
        }

        public GenericRepository<CompanyInfoCity> CompanyInfoCityRepository
        {
            get
            {
                if (this.companyInfoCityRepository == null)
                {
                    this.companyInfoCityRepository = new GenericRepository<CompanyInfoCity>(context);
                }
                return companyInfoCityRepository;
            }
        }

        public GenericRepository<Contact> ContactRepository
        {
            get
            {
                if (this.contactRepository == null)
                {
                    this.contactRepository = new GenericRepository<Contact>(context);
                }
                return contactRepository;
            }
        }

        public GenericRepository<DesiredBenefit> DesiredBenefitRepository
        {
            get
            {
                if (this.desiredBenefitRepository == null)
                {
                    this.desiredBenefitRepository = new GenericRepository<DesiredBenefit>(context);
                }
                return desiredBenefitRepository;
            }
        }

        public GenericRepository<EducationHistory> EducationHistoryRepository
        {
            get
            {
                if (this.educationHistoryRepository == null)
                {
                    this.educationHistoryRepository = new GenericRepository<EducationHistory>(context);
                }
                return educationHistoryRepository;
            }
        }

        public GenericRepository<EmploymentHistory> EmploymentHistoryRepository
        {
            get
            {
                if (this.employmentHistoryRepository == null)
                {
                    this.employmentHistoryRepository = new GenericRepository<EmploymentHistory>(context);
                }
                return employmentHistoryRepository;
            }
        }

        public GenericRepository<ExpectedCategory> ExpectedCategoryRepository
        {
            get
            {
                if (this.expectedCategoryRepository == null)
                {
                    this.expectedCategoryRepository = new GenericRepository<ExpectedCategory>(context);
                }
                return expectedCategoryRepository;
            }
        }

        public GenericRepository<ExpectedCity> ExpectedCityRepository
        {
            get
            {
                if (this.expectedCityRepository == null)
                {
                    this.expectedCityRepository = new GenericRepository<ExpectedCity>(context);
                }
                return expectedCityRepository;
            }
        }

        public GenericRepository<Job> JobRepository
        {
            get
            {
                if (this.jobRepository == null)
                {
                    this.jobRepository = new GenericRepository<Job>(context);
                }
                return jobRepository;
            }
        }

        public GenericRepository<JobBenefit> JobBenefitRepository
        {
            get
            {
                if (this.jobBenefitRepository == null)
                {
                    this.jobBenefitRepository = new GenericRepository<JobBenefit>(context);
                }
                return jobBenefitRepository;
            }
        }

        public GenericRepository<JobCategory> JobCategoryRepository
        {
            get
            {
                if (this.jobCategoryRepository == null)
                {
                    this.jobCategoryRepository = new GenericRepository<JobCategory>(context);
                }
                return jobCategoryRepository;
            }
        }

        public GenericRepository<JobCity> JobCityRepository
        {
            get
            {
                if (this.jobCityRepository == null)
                {
                    this.jobCityRepository = new GenericRepository<JobCity>(context);
                }
                return jobCityRepository;
            }
        }

        public GenericRepository<JobLanguage> JobLanguageRepository
        {
            get
            {
                if (this.jobLanguageRepository == null)
                {
                    this.jobLanguageRepository = new GenericRepository<JobLanguage>(context);
                }
                return jobLanguageRepository;
            }
        }

        public GenericRepository<JobLevel> JobLevelRepository
        {
            get
            {
                if (this.jobLevelRepository == null)
                {
                    this.jobLevelRepository = new GenericRepository<JobLevel>(context);
                }
                return jobLevelRepository;
            }
        }

        public GenericRepository<JobPackage> JobPackageRepository
        {
            get
            {
                if (this.jobPackageRepository == null)
                {
                    this.jobPackageRepository = new GenericRepository<JobPackage>(context);
                }
                return jobPackageRepository;
            }
        }

        public GenericRepository<Jobseeker> JobseekerRepository
        {
            get
            {
                if (this.jobseekerRepository == null)
                {
                    this.jobseekerRepository = new GenericRepository<Jobseeker>(context);
                }
                return jobseekerRepository;
            }
        }

        public GenericRepository<JobSkill> JobSkillRepository
        {
            get
            {
                if (this.jobSkillRepository == null)
                {
                    this.jobSkillRepository = new GenericRepository<JobSkill>(context);
                }
                return jobSkillRepository;
            }
        }

        public GenericRepository<Language> LanguageRepository
        {
            get
            {
                if (this.languageRepository == null)
                {
                    this.languageRepository = new GenericRepository<Language>(context);
                }
                return languageRepository;
            }
        }

        public GenericRepository<Level> LevelRepository
        {
            get
            {
                if (this.levelRepository == null)
                {
                    this.levelRepository = new GenericRepository<Level>(context);
                }
                return levelRepository;
            }
        }

        public GenericRepository<Manager> ManagerRepository
        {
            get
            {
                if (this.managerRepository == null)
                {
                    this.managerRepository = new GenericRepository<Manager>(context);
                }
                return managerRepository;
            }
        }

        public GenericRepository<Message> MessageRepository
        {
            get
            {
                if (this.messageRepository == null)
                {
                    this.messageRepository = new GenericRepository<Message>(context);
                }
                return messageRepository;
            }
        }

        public GenericRepository<MessageReceiver> MessageReceiverRepository
        {
            get
            {
                if (this.messageReceiverRepository == null)
                {
                    this.messageReceiverRepository = new GenericRepository<MessageReceiver>(context);
                }
                return messageReceiverRepository;
            }
        }

        public GenericRepository<OwnSkill> OwnSkillRepository
        {
            get
            {
                if (this.ownSkillRepository == null)
                {
                    this.ownSkillRepository = new GenericRepository<OwnSkill>(context);
                }
                return ownSkillRepository;
            }
        }

        public GenericRepository<Profile> ProfileRepository
        {
            get
            {
                if (this.profileRepository == null)
                {
                    this.profileRepository = new GenericRepository<Profile>(context);
                }
                return profileRepository;
            }
        }

        public GenericRepository<PurchaseAdvertise> PurchaseAdvertiseRepository
        {
            get
            {
                if (this.purchaseAdvertiseRepository == null)
                {
                    this.purchaseAdvertiseRepository = new GenericRepository<PurchaseAdvertise>(context);
                }
                return purchaseAdvertiseRepository;
            }
        }

        public GenericRepository<PurchaseJobPackage> PurchaseJobPackageRepository
        {
            get
            {
                if (this.purchaseJobPackageRepository == null)
                {
                    this.purchaseJobPackageRepository = new GenericRepository<PurchaseJobPackage>(context);
                }
                return purchaseJobPackageRepository;
            }
        }

        public GenericRepository<Recruiter> RecruiterRepository
        {
            get
            {
                if (this.recruiterRepository == null)
                {
                    this.recruiterRepository = new GenericRepository<Recruiter>(context);
                }
                return recruiterRepository;
            }
        }

        public GenericRepository<ReferencePerson> ReferencePersonRepository
        {
            get
            {
                if (this.referencePersonRepository == null)
                {
                    this.referencePersonRepository = new GenericRepository<ReferencePerson>(context);
                }
                return referencePersonRepository;
            }
        }

        public GenericRepository<Report> ReportRepository
        {
            get
            {
                if (this.reportRepository == null)
                {
                    this.reportRepository = new GenericRepository<Report>(context);
                }
                return reportRepository;
            }
        }

        public GenericRepository<SchoolLevel> SchoolLevelRepository
        {
            get
            {
                if (this.schoolLevelRepository == null)
                {
                    this.schoolLevelRepository = new GenericRepository<SchoolLevel>(context);
                }
                return schoolLevelRepository;
            }
        }

        public GenericRepository<Skill> SkillRepository
        {
            get
            {
                if (this.skillRepository == null)
                {
                    this.skillRepository = new GenericRepository<Skill>(context);
                }
                return skillRepository;
            }
        }

        public GenericRepository<Staff> StaffRepository
        {
            get
            {
                if (this.staffRepository == null)
                {
                    this.staffRepository = new GenericRepository<Staff>(context);
                }
                return staffRepository;
            }
        }

        public GenericRepository<Topic> TopicRepository
        {
            get
            {
                if (this.topicRepository == null)
                {
                    this.topicRepository = new GenericRepository<Topic>(context);
                }
                return topicRepository;
            }
        }

        public GenericRepository<ViewProfile> ViewProfileRepository
        {
            get
            {
                if (this.viewProfileRepository == null)
                {
                    this.viewProfileRepository = new GenericRepository<ViewProfile>(context);
                }
                return viewProfileRepository;
            }
        }

        public void Save()
        {
            context.SaveChanges();
        }

        private bool disposed = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    context.Dispose();
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