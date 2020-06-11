using DAL.Repositories.Interface;
using ORM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Repositories
{
    public class UnitOfWork : IUnitOfWork
    {

        public ServiceDB context { get; }

        private RoleRepository roleRepository;
        private UserRepository userRepository;
        private CertificateRepository certificateRepository;
        private EmployeeRepository employeeRepository;
        private CustomerRepository customerRepository;
        private TemplateRepository templateRepository;
        private ComponentRepository componentRepository;
        private IndustrialObjectRepository industrialObjectRepository;
        private MaterialRepository materialRepository;
        private EquipmentRepository equipmentRepository;
        private ControlMethodDocumentationRepository controlMethodDocumentationRepository;
        private RequirementDocumentationRepository requirementDocumentationRepository;
        private CertificateLibRepository certificateLibRepository;
        private ControlMethodsLibRepository controlMethodsLibRepository;
        private ControlNameLibRepository controlNameLibRepository;
        private ControlNameRepository controlNameRepository;
        private ControlRepository controlRepository;
        private ImageRepository imageRepository;
        private ImageLibRepository imageLibRepository;
        private JournalRepository journalRepository;
        private ResultRepository resultRepository;
        private WeldJointRepository weldJointRepository;
        private ComponentLibRepository componentLibRepository;
        private SelectedCertificateRepository selectedCertificateRepository;
        private SelectedComponentRepository selectedComponentRepository;
        private SelectedControlNameRepository selectedControlNameRepository;
        private ResultLibRepository resultLibRepository;
        private EquipmentLibRepository equipmentLibRepository;
        private SelectedEquipmentRepository selectedEquipmentRepository;
        private ControlMethodDocumentationLibRepository controlMethodDocumentationLibRepository;
        private SelectedControlMethodDocumentationRepository selectedControlMethodDocumentationRepository;
        private RequirementDocumentationLibRepository requirementDocumentationLibRepository;
        private SelectedRequirementDocumentationRepository selectedRequirementDocumentationRepository;
        private EmployeeLibRepository employeeLibRepository;
        private SelectedEmployeeRepository selectedEmployeeRepository;


        public IRoleRepository Roles 
            => roleRepository ?? (roleRepository = new RoleRepository(context));
        public IUserRepository Users
            => userRepository ?? (userRepository = new UserRepository(context));
        public ICertificateRepository Certificates
            => certificateRepository ?? (certificateRepository = new CertificateRepository(context));
        public IEmployeeRepository Employees
            => employeeRepository ?? (employeeRepository = new EmployeeRepository(context));
        public ICustomerRepository Customers
            => customerRepository ?? (customerRepository = new CustomerRepository(context));
        public ITemplateRepository Templates
            => templateRepository ?? (templateRepository = new TemplateRepository(context));
        public IComponentRepository Components
            => componentRepository ?? (componentRepository = new ComponentRepository(context));
        public IIndustrialObjectRepository IndustrialObjects
            => industrialObjectRepository ?? (industrialObjectRepository = new IndustrialObjectRepository(context));
        public IMaterialRepository Materials
            => materialRepository ?? (materialRepository = new MaterialRepository(context));
        public IEquipmentRepository Equipments
            => equipmentRepository ?? (equipmentRepository = new EquipmentRepository(context));
        public IControlMethodDocumentationRepository ControlMethodDocumentations
            => controlMethodDocumentationRepository ?? (controlMethodDocumentationRepository = new ControlMethodDocumentationRepository(context));
        public IRequirementDocumentationRepository RequirementDocumentations
            => requirementDocumentationRepository ?? (requirementDocumentationRepository = new RequirementDocumentationRepository(context));
        public ICertificateLibRepository CertificateLibs
            => certificateLibRepository ?? (certificateLibRepository = new CertificateLibRepository(context));
        public IControlMethodsLibRepository ControlMethodsLibs
            => controlMethodsLibRepository ?? (controlMethodsLibRepository = new ControlMethodsLibRepository(context));
        public IControlNameRepository ControlNames
            => controlNameRepository ?? (controlNameRepository = new ControlNameRepository(context));
        public IControlNameLibRepository ControlNameLibs
            => controlNameLibRepository ?? (controlNameLibRepository = new ControlNameLibRepository(context));
        public IControlRepository Controls
            => controlRepository ?? (controlRepository = new ControlRepository(context));
        public IImageRepository Images
            => imageRepository ?? (imageRepository = new ImageRepository(context));
        public IImageLibRepository ImageLibs
            => imageLibRepository ?? (imageLibRepository = new ImageLibRepository(context));
        public IJournalRepository Journals
            => journalRepository ?? (journalRepository = new JournalRepository(context));
        public IResultRepository Results
            => resultRepository ?? (resultRepository = new ResultRepository(context));
        public IWeldJointRepository WeldJoints
            => weldJointRepository ?? (weldJointRepository = new WeldJointRepository(context));
        public IComponentLibRepository ComponentLibs
            => componentLibRepository ?? (componentLibRepository = new ComponentLibRepository(context));
        public ISelectedCertificateRepository SelectedCertificates
            => selectedCertificateRepository ?? (selectedCertificateRepository = new SelectedCertificateRepository(context));
        public ISelectedComponentRepository SelectedComponents
            => selectedComponentRepository ?? (selectedComponentRepository = new SelectedComponentRepository(context));
        public ISelectedControlNameRepository SelectedControlNames
            => selectedControlNameRepository ?? (selectedControlNameRepository = new SelectedControlNameRepository(context));
        public IResultLibRepository ResultLibs
            => resultLibRepository ?? (resultLibRepository = new ResultLibRepository(context));
        public ISelectedEquipmentRepository SelectedEquipments
            => selectedEquipmentRepository ?? (selectedEquipmentRepository = new SelectedEquipmentRepository(context));
        public IEquipmentLibRepository EquipmentLibs
            => equipmentLibRepository ?? (equipmentLibRepository = new EquipmentLibRepository(context));
        public IControlMethodDocumentationLibRepository ControlMethodDocumentationLibs
            => controlMethodDocumentationLibRepository ?? (controlMethodDocumentationLibRepository = new ControlMethodDocumentationLibRepository(context));
        public ISelectedControlMethodDocumentationRepository SelectedControlMethodDocumentations
            => selectedControlMethodDocumentationRepository ?? (selectedControlMethodDocumentationRepository = new SelectedControlMethodDocumentationRepository(context));
        public IRequirementDocumentationLibRepository RequirementDocumentationLibs
            => requirementDocumentationLibRepository ?? (requirementDocumentationLibRepository = new RequirementDocumentationLibRepository(context));
        public ISelectedRequirementDocumentationRepository SelectedRequirementDocumentations
            => selectedRequirementDocumentationRepository ?? (selectedRequirementDocumentationRepository = new SelectedRequirementDocumentationRepository(context));
        public IEmployeeLibRepository EmployeeLibs
            => employeeLibRepository ?? (employeeLibRepository = new EmployeeLibRepository(context));
        public ISelectedEmployeeRepository SelectedEmployees
            => selectedEmployeeRepository ?? (selectedEmployeeRepository = new SelectedEmployeeRepository(context));

        public UnitOfWork(ServiceDB context)
        {
            this.context = context;
        }

        public void Commit()
        {
            context.SaveChanges();
        }
    }
}
