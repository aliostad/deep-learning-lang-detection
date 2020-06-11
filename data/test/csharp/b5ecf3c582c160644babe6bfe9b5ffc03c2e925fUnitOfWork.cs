using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using DataAccess.Repository;

namespace DataAccess.Class
{
    public class UnitOfWork
    {
        private EshopContext context = new EshopContext();
        private RepositoryAddress repositoryAddress;
        private RepositoryCategory repositoryCategory;
        private RepositoryOrder repositoryOrder;
        private RepositoryPage repositoryPage;
        private RepositoryProduct repositoryProduct;
        private RepositoryUser repositoryUser;
        private RepositoryRole repositoryRole;
        private RepositoryOrderHistory repositoryOrderHistory;
        private RepositoryGallery repositoryGallery;
        private RepositoryImage repositoryImage;
        private RepositoryFile repositoryFile;
        private RepositoryFileStorage repositoryFileStorage;
        
        public RepositoryDeliveryPayment RepositoryDeliveryPayment => new RepositoryDeliveryPayment(context);

        public RepositoryAddress RepositoryAddress
        {
            get
            {
                if (repositoryAddress == null)
                {
                    repositoryAddress = new RepositoryAddress(context);
                }

                return repositoryAddress;
            }
        }
        public RepositoryCategory RepositoryCategory
        {
            get
            {
                if (repositoryCategory == null)
                {
                    repositoryCategory = new RepositoryCategory(context);
                }

                return repositoryCategory;
            }
        }
        public RepositoryOrder RepositoryOrder
        {
            get
            {
                if (repositoryOrder == null)
                {
                    repositoryOrder = new RepositoryOrder(context);
                }

                return repositoryOrder;
            }
        }
        public RepositoryPage RepositoryPage
        {
            get
            {
                if (repositoryPage == null)
                {
                    repositoryPage = new RepositoryPage(context);
                }

                return repositoryPage;
            }
        }
        public RepositoryProduct RepositoryProduct
        {
            get
            {
                if (repositoryProduct == null)
                {
                    repositoryProduct = new RepositoryProduct(context);
                }

                return repositoryProduct;
            }
        }
        public RepositoryUser RepositoryUser
        {
            get
            {
                if (repositoryUser == null)
                {
                    repositoryUser = new RepositoryUser(context);
                }

                return repositoryUser;
            }
        }
        public RepositoryRole RepositoryRole
        {
            get
            {
                if (repositoryRole == null)
                {
                    repositoryRole = new RepositoryRole(context);
                }

                return repositoryRole;
            }
        }

        public RepositoryOrderHistory RepositoryOrderHistory
        {
            get
            {
                if (repositoryOrderHistory == null)
                {
                    repositoryOrderHistory = new RepositoryOrderHistory(context);
                }

                return repositoryOrderHistory;
            }
        }

        public RepositoryGallery RepositoryGallery
        {
            get
            {
                if (repositoryGallery == null)
                {
                    repositoryGallery = new RepositoryGallery(context);
                }

                return repositoryGallery;
            }
        }

        public RepositoryImage RepositoryImage
        {
            get
            {
                if (repositoryImage == null)
                {
                    repositoryImage = new RepositoryImage(context);
                }

                return repositoryImage;
            }
        }

        public RepositoryFile RepositoryFile
        {
            get
            {
                if (repositoryFile == null)
                {
                    repositoryFile = new RepositoryFile(context);
                }

                return repositoryFile;
            }
        }

        public RepositoryFileStorage RepositoryFileStorage
        {
            get
            {
                if (repositoryFileStorage == null)
                {
                    repositoryFileStorage = new RepositoryFileStorage(context);
                }

                return repositoryFileStorage;
            }
        }

        public int Save()
        {
            return context.SaveChanges();
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
