using Data;
using Data.Interfaces;
using Data.Models;
using Data.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace  Data.Infrastructure
{
    public class UnitOfWork : IUnitOfWork
    {
        private medtravdbContext dataContext;
        protected medtravdbContext DataContext
        {
            get
            {
                return dataContext = dbFactory.DataContext;
            }
        }

        IDatabaseFactory dbFactory;
        public UnitOfWork(IDatabaseFactory dbFactory)
        {
            this.dbFactory = dbFactory;
        }

        public UnitOfWork()
        {
        }

        public void Commit()
        {
            DataContext.SaveChanges();
        }






        private IHotelRepository hotelRepository;
        public IHotelRepository HotelRepository
        {
            get { return hotelRepository = new HotelRepository(dbFactory); ; }
        }

        private IUserRepository userRepository;
        public IUserRepository UserRepository
        {
            get { return userRepository = new UserRepository(dbFactory); ; }
        }

        private IServiceHotelRepository serviceHotelRepository;
        public IServiceHotelRepository ServiceHotelRepository
        {
            get { return serviceHotelRepository = new ServiceHotelRepository(dbFactory); ; }
        }


        private IHotelBookingRepository hotelBookingRepository;
        public IHotelBookingRepository HotelBookingRepository
        {
            get { return hotelBookingRepository = new HotelBookingRepository(dbFactory); ; }
        }

        private IClinicBookingRepository clinicBookingRepository;
        public IClinicBookingRepository ClinicBookingRepository
        {
            get { return clinicBookingRepository = new ClinicBookingRepository(dbFactory); ; }
        }

        private IClinicRepository clinicRepository;
        public IClinicRepository ClinicRepository
        {
            get { return clinicRepository = new ClinicRepository(dbFactory); ; }
        }



        private ISurgeryRepository surgeryRepository;
        public ISurgeryRepository SurgeryRepository
        {
            get { return surgeryRepository = new SurgeryRepository(dbFactory); ; }
        }


        private IDoctorPatientRepository doctorPatientRepository;
        public IDoctorPatientRepository DoctorPatientRepository
        {
            get { return doctorPatientRepository = new DoctorPatientRepository(dbFactory); ; }
        }

        private ISurgeryBookingRepository surgeryBookingRepository;
        public ISurgeryBookingRepository SurgeryBookingRepository
        {
            get { return surgeryBookingRepository = new SurgeryBookingRepository(dbFactory); ; }
        }
        private IMedicalRecordsRepository medicalRecordsRepository;
        public IMedicalRecordsRepository MedicalRecordsRepository
        {
            get { return medicalRecordsRepository = new MedicalRecordsRepository(dbFactory); ; }
        }


        private IFlightRepository flightRepository;
        public IFlightRepository FlightRepository
        {
            get { return flightRepository = new FlightRepository(dbFactory); ; }
        }

        private IFlightMatchingRepository flightMatchingRepository;
        public IFlightMatchingRepository FlightMatchingRepository
        {
            get { return flightMatchingRepository = new FlightMatchingRepository(dbFactory); ; }
        }

        private ITestimonyRepository testimonyRepository;
        public ITestimonyRepository TestimonyRepository
        {
            get { return testimonyRepository = new TestimonyRepository(dbFactory); ; }
        }

        private IQuestionRepository questionRepository;
        public IQuestionRepository QuestionRepository
        {
            get { return questionRepository = new QuestionRepository(dbFactory); ; }
        }

       

        private ITipRepository tipRepository;
        public ITipRepository TipRepository
        {
            get { return tipRepository = new TipRepository(dbFactory); ; }

        }
        public void Dispose()
        {
            DataContext.Dispose();
        }
        
    }
}
