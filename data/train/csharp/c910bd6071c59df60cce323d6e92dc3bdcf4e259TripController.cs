using Microsoft.AspNet.Mvc;
using MyTrips.Repository;

namespace MyTrips.Controllers
{

    public class TripController : Controller
    {
        private readonly ITripRepository _repository;
        private readonly IUserRepository _userRepository;

        public TripController(ITripRepository repository, IUserRepository userRepository)
        {

            _repository = repository;
            _userRepository = userRepository;
        }

        public IActionResult Index(long id)
        {
            return View();

        }
    }
}