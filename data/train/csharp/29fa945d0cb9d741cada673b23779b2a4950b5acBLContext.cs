using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Data.Repositories;
using Models;
using System.Data.Entity;

namespace BL
{
    public class BLContext
    {
        public ICarriageRepository _carriageRepository;
        public IPassageRepository _passageRepository;
        public ICombinationRepository _combinationRepository;
        public IStationRepository _stationRepository;
        //public ITicketRepository _ticketRepository;
        public IPlaceRepository _placeRepository;
        //public IUserRepository _userRepository;

        public BLContext(MyDBContext dbcontext)
        {
            _carriageRepository = new CarriageRepository(dbcontext);
            _passageRepository = new PassageRepository(dbcontext);
            _combinationRepository = new CombinationRepository(dbcontext);
            _stationRepository = new StationRepository(dbcontext);
            //_ticketRepository = new TicketRepository(dbcontext);
            _placeRepository = new PlaceRepository(dbcontext);
            //_userRepository = new UserRepository(dbcontext);
        }
    }
}
