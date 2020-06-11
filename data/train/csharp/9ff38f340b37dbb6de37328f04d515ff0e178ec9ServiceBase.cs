using CRUD.Repository;
using CRUD.Repository.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRUD.Service
{
    public abstract class ServiceBase
    {
        private IContactRepository contactRepository;
        protected IContactRepository GetContactRepository()
        {
            if (contactRepository == null)
                contactRepository = new ContactRepository();
            return contactRepository;
        }

        private IPhoneRepository phoneRepository;
        protected IPhoneRepository GetPhoneRepository()
        {
            if (phoneRepository == null)
                phoneRepository = new PhoneRepository();
            return phoneRepository;
        }
    }
}
