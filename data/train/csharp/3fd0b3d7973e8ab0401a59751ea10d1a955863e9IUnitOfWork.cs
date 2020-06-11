using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Model
{
    public interface IUnitOfWork:IDisposable
    {
        IGenericRepository<Address> AdressRepository { get; }
        IGenericRepository<Area> AreaRepository { get; }
        IGenericRepository<Booking> BookingRepository { get; }
        IGenericRepository<Company> CompanyRepository { get; }
        IGenericRepository<Contact> ContactRepository { get; }
        IGenericRepository<Category> CategoryRepository { get; }
        IGenericRepository<Detail> DetailRepository { get; }
        IGenericRepository<DetailAllocation> DetailAllocationRepository { get; }
        IGenericRepository<Event> EventRepository { get; }
        IGenericRepository<Lecturer> LectureRepository { get; }
        IGenericRepository<Location> LocationRepository { get; }
        IGenericRepository<Person> PersonRepository { get; }
        IGenericRepository<Presentation> PresentationRepository { get; }
        IGenericRepository<Representative> RepresentativeRepository { get; }
        IGenericRepository<Resource> ResourceRepository { get; }
        IGenericRepository<ResourceBooking> ResourceBookingRepository { get; }


        void Save();

        void DeleteDatabase();


        void AttachTag(Tag t);

        void DetachCompany(Company t);
    }
}
