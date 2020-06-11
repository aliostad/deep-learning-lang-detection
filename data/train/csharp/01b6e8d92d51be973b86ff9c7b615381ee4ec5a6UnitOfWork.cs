using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Data.Objects.DataClasses;
using DRMFSS.BLL.Interfaces;
using DRMFSS.BLL.Repository;


namespace DRMFSS.BLL
{

    public class UnitOfWork : IUnitOfWork, IDisposable
    {
        

        private readonly CTSContext _context;
        public UnitOfWork()
        {
            _context= new CTSContext();
        }

        #region Fields
        private IGenericRepository<Account> _AccountRepository = null;
        private IGenericRepository<Adjustment> _AdjustmentRepository = null;
        private IGenericRepository<AdjustmentReason> _AdjustmentReasonRepository = null;
        private IGenericRepository<AdminUnit> _AdminUnitRepository = null;
        private IGenericRepository<AdminUnitType> _AdminUnitTypeRepository = null;
        private IGenericRepository<Audit> _AuditRepository = null;
        private IGenericRepository<Commodity> _CommodityRepository = null;
        private IGenericRepository<CommodityGrade> _CommodityGradeRepository = null;
        private IGenericRepository<CommoditySource> _CommoditySourceRepository = null;
        private IGenericRepository<CommodityType> _CommodityTypeRepository = null;
        private IGenericRepository<Contact> _ContactRepository = null;
        private IGenericRepository<Detail> _DetailRepository = null;
        private IGenericRepository<Dispatch> _DispatchRepository = null;
        private IGenericRepository<DispatchAllocation> _DispatchAllocationRepository = null;
        private IGenericRepository<DispatchDetail> _DispatchDetailRepository = null;
        private IGenericRepository<Donor> _DonorRepository = null;
        private IGenericRepository<FDP> _FDPRepository = null;
        private IGenericRepository<ForgetPasswordRequest> _ForgetPasswordRequestRepository = null;
        private IGenericRepository<GiftCertificate> _GiftCertificateRepository = null;
        private IGenericRepository<GiftCertificateDetail> _GiftCertificateDetailRepository = null;
        private IGenericRepository<Hub> _HubRepository = null;
        private IGenericRepository<HubOwner> _HubOwnerRepository = null;
        private IGenericRepository<HubSetting> _HubSettingRepository = null;
        private IGenericRepository<HubSettingValue> _HubSettingValueRepository = null;
        private IGenericRepository<InternalMovement> _InternalMovementRepository = null;
        private IGenericRepository<Ledger> _LedgerRepository = null;
        private IGenericRepository<LedgerType> _LedgerTypeRepository = null;
        private IGenericRepository<LetterTemplate> _LetterTemplateRepository = null;
        private IGenericRepository<Master> _MasterRepository = null;
        private IGenericRepository<OtherDispatchAllocation> _OtherDispatchAllocationRepository = null;
        private IGenericRepository<Partition> _PartitionRepository = null;
        private IGenericRepository<Period> _PeriodRepository = null;
        private IGenericRepository<Program> _ProgramRepository = null;
        private IGenericRepository<ProjectCode> _ProjectCodeRepository = null;
        private IGenericRepository<ReceiptAllocation> _ReceiptAllocationRepository = null;
        private IGenericRepository<Receive> _ReceiveRepository = null;
        private IGenericRepository<ReceiveDetail> _ReceiveDetailRepository = null;
        private IGenericRepository<ReleaseNote> _ReleaseNoteRepository = null;
        private IGenericRepository<Role> _RoleRepository = null;
        private IGenericRepository<SessionAttempt> _SessionAttemptRepository = null; 
        private IGenericRepository<SessionHistory> _SessionHistoryRepository = null;
        private IGenericRepository<Setting> _SettingRepository = null;
        private IGenericRepository<ShippingInstruction> _ShippingInstructionRepository = null;
        private IGenericRepository<StackEvent> _StackEventRepository = null;
        private IGenericRepository<SMS> _SMSRepository = null;
        private IGenericRepository<StackEventType> _StackEventTypeRepository = null;
        private IGenericRepository<Store> _StoreRepository = null;
        private IGenericRepository<Transaction> _TransactionRepository = null;
        private IGenericRepository<TransactionGroup> _TransactionGroupRepository = null;
        private IGenericRepository<Translation> _TranslationRepository = null;
        private IGenericRepository<Transporter> _TransporterRepository = null;
        private IGenericRepository<Unit> _UnitRepository = null;
        private IGenericRepository<UserHub> _UserHubRepository = null;
        private IGenericRepository<UserProfile> _UserProfileRepository = null;
        private IGenericRepository<UserRole> _UserRoleRepository = null;
        private IReportRepository _reportRepository = null;

        #endregion

        #region Property
       public  IGenericRepository< Account> AccountRepository
        {
            get { return this._AccountRepository ?? (this._AccountRepository = new GenericRepository<Account>(_context)); }
           
        }

      
       public  IGenericRepository<Adjustment>AdjustmentRepository 
        {


            get { return this._AdjustmentRepository ?? (this._AdjustmentRepository = new GenericRepository<Adjustment>(_context)); }
            
      
        }

       
       public  IGenericRepository<AdjustmentReason>AdjustmentReasonRepository 
        {


            get { return this._AdjustmentReasonRepository ?? (this._AdjustmentReasonRepository = new GenericRepository<AdjustmentReason>(_context)); }

      
        }

       
       public  IGenericRepository<AdminUnit>AdminUnitRepository 
        {


            get { return this._AdminUnitRepository ?? (this._AdminUnitRepository = new GenericRepository<AdminUnit>(_context)); }

      
        }

   
       public  IGenericRepository<AdminUnitType>AdminUnitTypeRepository 
        {


            get { return this._AdminUnitTypeRepository ?? (this._AdminUnitTypeRepository = new GenericRepository<AdminUnitType>(_context)); }

        }

        
       public  IGenericRepository<Audit>AuditRepository
       {

           get { return this._AuditRepository ?? (this._AuditRepository = new GenericRepository<Audit>(_context)); }

      
        }

   
       public  IGenericRepository<Commodity>CommodityRepository 
        {


            get { return this._CommodityRepository ?? (this._CommodityRepository = new GenericRepository<Commodity>(_context)); }

        }

       
       public  IGenericRepository<CommodityGrade>CommodityGradeRepository 
        {


            get { return this._CommodityGradeRepository ?? (this._CommodityGradeRepository = new GenericRepository<CommodityGrade>(_context)); }

      
        }

       
       public  IGenericRepository<CommoditySource>CommoditySourceRepository 
        {


            get { return this._CommoditySourceRepository ?? (this._CommoditySourceRepository = new GenericRepository<CommoditySource>(_context)); }

      
        }

       
       public  IGenericRepository<CommodityType>CommodityTypeRepository 
        {


            get { return this._CommodityTypeRepository ?? (this._CommodityTypeRepository = new GenericRepository<CommodityType>(_context)); }

      
        }

       
       public  IGenericRepository<Contact>ContactRepository 
        {


            get { return this._ContactRepository ?? (this._ContactRepository = new GenericRepository<Contact>(_context)); }


      
        }

        
       public  IGenericRepository<Detail>DetailRepository 
        {


            get { return this._DetailRepository ?? (this._DetailRepository = new GenericRepository<Detail>(_context)); }

      
        }

        
       public  IGenericRepository<Dispatch>DispatchRepository 
        {


            get { return this._DispatchRepository ?? (this._DispatchRepository = new GenericRepository<Dispatch>(_context)); }

      
        }

        
       public  IGenericRepository<DispatchAllocation>DispatchAllocationRepository 
        {


            get { return this._DispatchAllocationRepository ?? (this._DispatchAllocationRepository = new GenericRepository<DispatchAllocation>(_context)); }

      
        }

      
       public  IGenericRepository<DispatchDetail>DispatchDetailRepository
       {

           get { return this._DispatchDetailRepository ?? (this._DispatchDetailRepository = new GenericRepository<DispatchDetail>(_context)); }

      
        }

       
       public  IGenericRepository<Donor>DonorRepository 
        {


            get { return this._DonorRepository ?? (this._DonorRepository = new GenericRepository<Donor>(_context)); }

      
        }

        
       public  IGenericRepository<FDP>FDPRepository 
        {


            get { return this._FDPRepository ?? (this._FDPRepository = new GenericRepository<FDP>(_context)); }

      
        }

       
       public  IGenericRepository<ForgetPasswordRequest>ForgetPasswordRequestRepository 
        {


            get { return this._ForgetPasswordRequestRepository ?? (this._ForgetPasswordRequestRepository = new GenericRepository<ForgetPasswordRequest>(_context)); }

      
        }

      
       public  IGenericRepository<GiftCertificate>GiftCertificateRepository 
        {


            get { return this._GiftCertificateRepository ?? (this._GiftCertificateRepository = new GenericRepository<GiftCertificate>(_context)); }

      
        }

    
       public  IGenericRepository<GiftCertificateDetail>GiftCertificateDetailRepository 
        {


            get { return this._GiftCertificateDetailRepository ?? (this._GiftCertificateDetailRepository = new GenericRepository<GiftCertificateDetail>(_context)); }

      
        }

        
       public  IGenericRepository<Hub>HubRepository 
        {


            get { return this._HubRepository ?? (this._HubRepository = new GenericRepository<Hub>(_context)); }

      
        }

       
       public  IGenericRepository<HubOwner>HubOwnerRepository 
        {


            get { return this._HubOwnerRepository ?? (this._HubOwnerRepository = new GenericRepository<HubOwner>(_context)); }

      
        }

        
       public  IGenericRepository<HubSetting>HubSettingRepository 
        {


            get { return this._HubSettingRepository ?? (this._HubSettingRepository = new GenericRepository<HubSetting>(_context)); }

      
        }

       
       public  IGenericRepository<HubSettingValue>HubSettingValueRepository 
        {


            get { return this._HubSettingValueRepository ?? (this._HubSettingValueRepository = new GenericRepository<HubSettingValue>(_context)); }

      
        }

       
       public  IGenericRepository<InternalMovement>InternalMovementRepository 
        {


            get { return this._InternalMovementRepository ?? (this._InternalMovementRepository = new GenericRepository<InternalMovement>(_context)); }

      
        }

       
       public  IGenericRepository<Ledger>LedgerRepository 
        {


            get { return this._LedgerRepository ?? (this._LedgerRepository = new GenericRepository<Ledger>(_context)); }

      
        }

        
       public  IGenericRepository<LedgerType>LedgerTypeRepository 
        {


            get { return this._LedgerTypeRepository ?? (this._LedgerTypeRepository = new GenericRepository<LedgerType>(_context)); }

      
        }

        
       public  IGenericRepository<LetterTemplate>LetterTemplateRepository 
        {


            get { return this._LetterTemplateRepository ?? (this._LetterTemplateRepository = new GenericRepository<LetterTemplate>(_context)); }

      
        }

     
       public  IGenericRepository<Master>MasterRepository 
        {


            get { return this._MasterRepository ?? (this._MasterRepository = new GenericRepository<Master>(_context)); }

      
        }

     
       public  IGenericRepository<OtherDispatchAllocation>OtherDispatchAllocationRepository 
        {


            get { return this._OtherDispatchAllocationRepository ?? (this._OtherDispatchAllocationRepository = new GenericRepository<OtherDispatchAllocation>(_context)); }

      
        }

        
       public  IGenericRepository<Partition>PartitionRepository 
        {


            get { return this._PartitionRepository ?? (this._PartitionRepository = new GenericRepository<Partition>(_context)); }

      
        }

       
       public  IGenericRepository<Period>PeriodRepository 
        {


            get { return this._PeriodRepository ?? (this._PeriodRepository = new GenericRepository<Period>(_context)); }

      
        }

       
       public  IGenericRepository<Program>ProgramRepository 
        {


            get { return this._ProgramRepository ?? (this._ProgramRepository = new GenericRepository<Program>(_context)); }

      
        }

       
       public  IGenericRepository<ProjectCode>ProjectCodeRepository 
        {


            get { return this._ProjectCodeRepository ?? (this._ProjectCodeRepository = new GenericRepository<ProjectCode>(_context)); }

      
        }

        
       public  IGenericRepository<ReceiptAllocation>ReceiptAllocationRepository 
        {


            get { return this._ReceiptAllocationRepository ?? (this._ReceiptAllocationRepository = new GenericRepository<ReceiptAllocation>(_context)); }

      
        }

        
       public  IGenericRepository<Receive>ReceiveRepository 
        {


            get { return this._ReceiveRepository ?? (this._ReceiveRepository = new GenericRepository<Receive>(_context)); }

      
        }

       
       public  IGenericRepository<ReceiveDetail>ReceiveDetailRepository 
        {


            get { return this._ReceiveDetailRepository ?? (this._ReceiveDetailRepository = new GenericRepository<ReceiveDetail>(_context)); }

      
        }

       
       public  IGenericRepository<ReleaseNote>ReleaseNoteRepository 
        {


            get { return this._ReleaseNoteRepository ?? (this._ReleaseNoteRepository = new GenericRepository<ReleaseNote>(_context)); }

      
        }

        
       public  IGenericRepository<Role>RoleRepository 
        {


            get { return this._RoleRepository ?? (this._RoleRepository = new GenericRepository<Role>(_context)); }

      
        }

      
       public  IGenericRepository<SessionAttempt>SessionAttemptRepository 
        {


            get { return this._SessionAttemptRepository ?? (this._SessionAttemptRepository = new GenericRepository<SessionAttempt>(_context)); }

      
        }

       
       public  IGenericRepository<SessionHistory>SessionHistoryRepository 
        {


            get { return this._SessionHistoryRepository ?? (this._SessionHistoryRepository = new GenericRepository<SessionHistory>(_context)); }

      
        }

      
       public  IGenericRepository<Setting>SettingRepository 
        {


            get { return this._SettingRepository ?? (this._SettingRepository = new GenericRepository<Setting>(_context)); }

      
        }

        
       public  IGenericRepository<ShippingInstruction>ShippingInstructionRepository 
        {


            get { return this._ShippingInstructionRepository ?? (this._ShippingInstructionRepository = new GenericRepository<ShippingInstruction>(_context)); }

      
        }
     

       public  IGenericRepository<SMS>SMSRepository 
        {


            get { return this._SMSRepository ?? (this._SMSRepository = new GenericRepository<SMS>(_context)); }

      
        }

       
       public  IGenericRepository<StackEvent>StackEventRepository 
        {


            get { return this._StackEventRepository ?? (this._StackEventRepository = new GenericRepository<StackEvent>(_context)); }

      
        }

      
       public  IGenericRepository<StackEventType>StackEventTypeRepository 
        {


            get { return this._StackEventTypeRepository ?? (this._StackEventTypeRepository = new GenericRepository<StackEventType>(_context)); }

      
        }

       
       public  IGenericRepository<Store>StoreRepository 
        {


            get { return this._StoreRepository ?? (this._StoreRepository = new GenericRepository<Store>(_context)); }

      
        }

        
       public  IGenericRepository<Transaction>TransactionRepository 
        {


            get { return this._TransactionRepository ?? (this._TransactionRepository = new GenericRepository<Transaction>(_context)); }

      
        }

        
       public  IGenericRepository<TransactionGroup>TransactionGroupRepository 
        {


            get { return this._TransactionGroupRepository ?? (this._TransactionGroupRepository = new GenericRepository<TransactionGroup>(_context)); }

      
        }

    
       public  IGenericRepository<Translation>TranslationRepository 
        {


            get { return this._TranslationRepository ?? (this._TranslationRepository = new GenericRepository<Translation>(_context)); }

      
        }

       
       public  IGenericRepository<Transporter>TransporterRepository 
        {


            get { return this._TransporterRepository ?? (this._TransporterRepository = new GenericRepository<Transporter>(_context)); }

      
        }

    
       public  IGenericRepository<Unit>UnitRepository 
        {


            get { return this._UnitRepository ?? (this._UnitRepository = new GenericRepository<Unit>(_context)); }

      
        }

       
       public  IGenericRepository<UserHub>UserHubRepository 
        {


            get { return this._UserHubRepository ?? (this._UserHubRepository = new GenericRepository<UserHub>(_context)); }

      
        }

        
       public  IGenericRepository<UserProfile>UserProfileRepository 
        {


            get { return this._UserProfileRepository ?? (this._UserProfileRepository = new GenericRepository<UserProfile>(_context)); }

      
        }

       
       public  IGenericRepository<UserRole>UserRoleRepository 
        {


            get { return this._UserRoleRepository ?? (this._UserRoleRepository = new GenericRepository<UserRole>(_context)); }

      
        }

        #endregion
       #region Methods
       public void Save()
       {
           _context.SaveChanges();
       }

       private bool disposed = false;


       protected virtual void Dispose(bool disposing)
       {
           if (!this.disposed)
           {
               if (disposing)
               {
                   _context.Dispose();
               }
           }
           this.disposed = true;
       }


       public void Dispose()
       {
           Dispose(true);
           GC.SuppressFinalize(this);
       }
       #endregion


       public IReportRepository ReportRepository
       {
           get { return this._reportRepository ?? (this._reportRepository = new ReportRepository(_context)); }
       }
    }
}


