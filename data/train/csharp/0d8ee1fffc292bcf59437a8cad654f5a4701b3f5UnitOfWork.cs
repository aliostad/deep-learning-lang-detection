using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using data.Models;
using data.Repositories;

namespace data.Infrastructure
{
    public class UnitOfWork : IUnitOfWork
    {
        private jpadbContext dataContext;
        DatabaseFactory dbFactory;

        public UnitOfWork(DatabaseFactory dbFactory)
        {
            this.dbFactory = dbFactory;
        }


        protected jpadbContext DataContext
        {
            get
            {
                return dataContext ?? (dataContext = dbFactory.Get());
            }
        }




        private IDoctorRepository doctorRepository;
        IDoctorRepository IUnitOfWork.DoctorRepository
        {
            get { return doctorRepository ?? (doctorRepository = new DoctorRepository(dbFactory)); }
        }
        private IOfferRepository offerRepository;
        IOfferRepository IUnitOfWork.OfferRepository
        {
            get { return offerRepository ?? (offerRepository = new OfferRepository(dbFactory)); }
        }
        private IConsultationRepository consultationRepository;
        IConsultationRepository IUnitOfWork.ConsultationRepository
        {
            get { return consultationRepository ?? (consultationRepository = new ConsultationRepository(dbFactory)); }
        }
        private IDocdispRepository doctordispRepository;
        IDocdispRepository IUnitOfWork.DoctordispRepository
        {
            get { return doctordispRepository ?? (doctordispRepository = new DocdispRepository(dbFactory)); }
        }
        private IAuthentificationRepository user1Repository;
        IAuthentificationRepository IUnitOfWork.AuthentificationRepository
        {
            get { return user1Repository ?? (user1Repository = new AuthentificationRepository(dbFactory)); }
        }
        //AMIRA
        private ICongeRepository congeRepository;
        public ICongeRepository CongeRepository
        {
            get
            {
                return congeRepository = new CongeRepository(dbFactory);
            }
        }

        private ITimetableRepository timetableRepository;
        public ITimetableRepository TimetableRepository
        {
            get
            {
                return timetableRepository = new TimetableRepository(dbFactory);
            }
        }

        //END AMIRA

        public void commit()
        {
            DataContext.SaveChanges();
        }

        //Wassila

        private ITransportCompagnieRepository expenseRepositoriii;
        ITransportCompagnieRepository IUnitOfWork.TransportCompagnieRepository
        {
            get
            {
                return expenseRepositoriii ?? (expenseRepositoriii = new
         TransportCompagnieRepository(dbFactory));
            }
        }


        private IDemandeRepository expenseRepositort;
        IDemandeRepository IUnitOfWork.DemandeRepository
        {
            get
            {
                return expenseRepositort ?? (expenseRepositort = new
         DemandeRepository(dbFactory));
            }
        }
        //End wassila

        //Takwa
        private IEventRepository eventRepository;
        IEventRepository IUnitOfWork.EventRepository
        {
            get { return eventRepository ?? (eventRepository = new EventRepository(dbFactory)); }
        }

        //end takwa

        //amine

        private IInsurance_offerRepository expenseRepositori;
        IInsurance_offerRepository IUnitOfWork.Insurance_offerRepository
        {
            get
            {
                return expenseRepositori ?? (expenseRepositori = new
         Insurance_offerRepository(dbFactory));
            }
        }


        private IStaffRepository staffRepository;
        public IStaffRepository StaffRepository
        {
            get { return staffRepository = new StaffRepository(dbFactory); }
        }

        //end amine

        //Mehdi
        private IHotelRepository hotelRepository;
        IHotelRepository IUnitOfWork.HotelRepository
        {
            get { return hotelRepository ?? (hotelRepository = new HotelRepository(dbFactory)); }
        }

        private IUserRepository userRepository;
        IUserRepository IUnitOfWork.UserRepository
        {
            get { return userRepository ?? (userRepository = new UserRepository(dbFactory)); }
        }


        private IReservationRepository reservationRepository;
        IReservationRepository IUnitOfWork.ReservationRepository
        {
            get { return reservationRepository ?? (reservationRepository = new ReservationRepository(dbFactory)); }
        }

        //Mehdi


    }
}
