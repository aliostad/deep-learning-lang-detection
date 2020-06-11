using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AQRWebApp.Model;
using AQRWebApp.Model.Entity;

namespace AQRWebApp.DAL
{
    public class UnitOfWork: IDisposable
    {
        private AQRWebAppDbContext context = new AQRWebAppDbContext();
        private GenericRepository<AppInfo> appInfoRepository;
        private GenericRepository<Client> clientRepository;
        private GenericRepository<Colour> colourRepository;
        private GenericRepository<Delivery> deliveryRepository;
        private GenericRepository<FileInfo> fileInfoRepository;
        private GenericRepository<Partner> partnerRepository;
        private GenericRepository<PartnerStore> partnerStoreRepository;
        private GenericRepository<Product> productRepository;
        private GenericRepository<Receive> receiveRepository;
        private GenericRepository<ShipmentId> shipmentIdRepository;
        private GenericRepository<ShipmentRegister> shipmentRegisterRepository;
        private GenericRepository<Size> sizeRepository;
        private GenericRepository<SizeGroup> sizeGroupRepository;
        private GenericRepository<Style> styleRepository;
        private GenericRepository<ClientPartner> clientPartnerRepository;
        private GenericRepository<Gender> genderRepository;
        private GenericRepository<Person> personRepository;
        private GenericRepository<PersonAccount> personAccountRepository;
        private GenericRepository<ChucDanh> chucDanhRepository;
        private GenericRepository<Department> departmentRepository;

        public AQRWebAppDbContext DataContext
        {
            get
            {
                return context;
            }
        }

        public GenericRepository<Department> DepartmentRepository
        {
            get
            {
                this.departmentRepository = new GenericRepository<Department>(context);
                return departmentRepository;
            }
        }

        public GenericRepository<ChucDanh> ChucDanhRepository
        {
            get
            {
                this.chucDanhRepository = new GenericRepository<ChucDanh>(context);
                return chucDanhRepository;
            }
        }

        public GenericRepository<PersonAccount> PersonAccountRepository
        {
            get
            {
                this.personAccountRepository = new GenericRepository<PersonAccount>(context);
                return personAccountRepository;
            }
        }

        public GenericRepository<Person> PersonRepository
        {
            get
            {
                this.personRepository = new GenericRepository<Person>(context);
                return personRepository;
            }
        }

        public GenericRepository<Gender> GenderRepository
        {
            get
            {
                this.genderRepository = new GenericRepository<Gender>(context);
                return genderRepository;
            }
        }

        public GenericRepository<AppInfo> AppInfoRepository
        {
            get
            {
                this.appInfoRepository = new GenericRepository<AppInfo>(context);
                return appInfoRepository;
            }
        }

        public GenericRepository<Client> ClientRepository
        {
            get
            {
                this.clientRepository = new GenericRepository<Client>(context);
                return clientRepository;
            }
        }

        public GenericRepository<Colour> ColourRepository
        {
            get
            {
                this.colourRepository = new GenericRepository<Colour>(context);
                return colourRepository;
            }
        }

        public GenericRepository<Delivery> DeliveryRepository
        {
            get
            {
                this.deliveryRepository = new GenericRepository<Delivery>(context);
                return deliveryRepository;
            }
        }

        public GenericRepository<FileInfo> FileInfoRepository
        {
            get
            {
                this.fileInfoRepository = new GenericRepository<FileInfo>(context);
                return fileInfoRepository;
            }
        }

        public GenericRepository<Partner> PartnerRepository
        {
            get
            {
                this.partnerRepository = new GenericRepository<Partner>(context);
                return partnerRepository;
            }
        }

        public GenericRepository<PartnerStore> PartnerStoreRepository
        {
            get
            {
                this.partnerStoreRepository = new GenericRepository<PartnerStore>(context);
                return partnerStoreRepository;
            }
        }

        public GenericRepository<Product> ProductRepository
        {
            get
            {
                this.productRepository = new GenericRepository<Product>(context);
                return productRepository;
            }
        }

        public GenericRepository<Receive> ReceiveRepository
        {
            get
            {
                this.receiveRepository = new GenericRepository<Receive>(context);
                return receiveRepository;
            }
        }

        public GenericRepository<ShipmentId> ShipmentIdRepository
        {
            get
            {
                this.shipmentIdRepository = new GenericRepository<ShipmentId>(context);
                return shipmentIdRepository;
            }
        }

        public GenericRepository<ShipmentRegister> ShipmentRegisterRepository
        {
            get
            {
                this.shipmentRegisterRepository = new GenericRepository<ShipmentRegister>(context);
                return shipmentRegisterRepository;
            }
        }

        public GenericRepository<Size> SizeRepository
        {
            get
            {
                this.sizeRepository = new GenericRepository<Size>(context);
                return sizeRepository;
            }
        }

        public GenericRepository<SizeGroup> SizeGroupRepository
        {
            get
            {
                this.sizeGroupRepository = new GenericRepository<SizeGroup>(context);
                return sizeGroupRepository;
            }
        }

        public GenericRepository<Style> StyleRepository
        {
            get
            {
                this.styleRepository = new GenericRepository<Style>(context);
                return styleRepository;
            }
        }

        public GenericRepository<ClientPartner> ClientPartnerRepository
        {
            get
            {
                this.clientPartnerRepository = new GenericRepository<ClientPartner>(context);
                return clientPartnerRepository;
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
